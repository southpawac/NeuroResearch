for window=1:size(data.coherency_matrix,3)
    data.coherency_graph(window) = graph(coherency_matrix(:,:,window));
    data.coherency_graph_centrality(window) = centrality(coherency_graph(window), 'eigenvector', 'importance', data.coherency_graph(window));
end