Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3HMPBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:01:49 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:47210 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756937Ab3HMPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:01:47 -0400
X-IronPort-AV: E=Sophos;i="4.89,870,1367964000"; 
   d="scan'208";a="29267787"
Date: Tue, 13 Aug 2013 17:01:28 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: grant.likely@linaro.org, rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: question about drivers/net/ethernet/nxp/lpc_eth.c
Message-ID: <alpine.DEB.2.02.1308131658460.2263@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder why drivers/net/ethernet/nxp/lpc_eth.c uses dev_alloc_skb in the
function __lpc_handle_recv, rather than netdev_alloc_skb?  The difference
seems to be only that with dev_alloc_skb, the dev field of the skb is
initialized to NULL, rather than to a net_device, but this function seems
to have a net_device value available, so I wonder why it is not used?

thanks,
julia
