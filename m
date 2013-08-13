Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3HMG32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:29:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28778 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab3HMG31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:29:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,867,1367964000"; 
   d="scan'208";a="29209572"
Date: Tue, 13 Aug 2013 08:29:24 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Francois Romieu <romieu@fr.zoreil.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, grant.likely@linaro.org,
        rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: question about netif_rx
In-Reply-To: <20130813052036.GA11640@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1308130828550.1997@localhost6.localdomain6>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6> <20130811155640.GA10070@electric-eye.fr.zoreil.com> <alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6> <20130813052036.GA11640@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1654509347-1376375365=:1997"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1654509347-1376375365=:1997
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 13 Aug 2013, Francois Romieu wrote:

> Julia Lawall <julia.lawall@lip6.fr> :
> > François Romieu <romieu@fr.zoreil.com> :
> [...]
> > > Can you send a netif_receive_skb replacement patch for it ?
> > 
> > Just to be sure, I just replace netif_rx by netif_receive_skb, nothing
> > else?
> 
> Yes. It should imho be fine with a comment incluing your analysis and a
> few words about the current state of checksum offloading support.

I wouldn't know what to say about the checksum part.  It is not supported 
so I should use netif_receive_skb?

thanks,
julia
--8323328-1654509347-1376375365=:1997--
