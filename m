Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3HMFUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:20:44 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:46049 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3HMFUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:20:43 -0400
Date: Tue, 13 Aug 2013 07:20:36 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: question about netif_rx
Message-ID: <20130813052036.GA11640@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
 <20130811155640.GA10070@electric-eye.fr.zoreil.com>
 <alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> :
> François Romieu <romieu@fr.zoreil.com> :
[...]
> > Can you send a netif_receive_skb replacement patch for it ?
> 
> Just to be sure, I just replace netif_rx by netif_receive_skb, nothing
> else?

Yes. It should imho be fine with a comment incluing your analysis and a
few words about the current state of checksum offloading support.

-- 
Ueimor
