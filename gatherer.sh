echo "Gathering info"
WORKDIR=collecing_data_$(date +%Y%m%d%H%m%s)
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

oc adm must-gather

echo "Gathering info namespaces"
NAMESPACES=$(oc get namespaces -o name)
for NS in $NAMESPACES; do
  oc adm inspect "${NS}"
done

echo "Gathering info nodes"

oc get nodes >nodes.txt

NODES=$(oc get nodes -o name)

for node in $NODES; do
  node_part=$(echo $node | sed 's|node/||')
  oc describe node "${node_part}" > "desc-${node_part}.txt"
done

oc adm top nodes >top-nodes.txt

echo "Gathering info pods"
oc adm top pod >top-pods.txt

cd -
tar zfvc "${WORKDIR}.tar.gz" "${WORKDIR}/"
