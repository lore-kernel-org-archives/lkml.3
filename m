Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaIQMoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:44:00 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44605 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbaIQMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:43:59 -0400
Date: Wed, 17 Sep 2014 15:43:54 +0300 (EEST)
From: mroos@linux.ee
To: Neil Horman <nhorman@tuxdriver.com>
cc: David Miller <davem@davemloft.net>, steffen@klassert.de,
        netdev@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bisected regression: 3c59x corrupts packets in 3.17-rc5
In-Reply-To: <20140917102701.GA5699@hmsreliant.think-freely.org>
Message-ID: <alpine.LRH.2.11.1409171529350.26961@adalberg.ut.ee>
References: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee> <20140916101704.GA3792@hmsreliant.think-freely.org> <20140916.162923.605101746131407931.davem@davemloft.net> <20140917102701.GA5699@hmsreliant.think-freely.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Shit, you're right, sorry about that.  Its odd, I'm running it here, and its not 
> causing problems, but thats obviously wrong.  Meelis, please add the above fix
> to your test and confirm that it sovles the problem.  If you could keep the
> previous patch in place too that would be great, as we should probably add the
> dma error checking anyway.
> 
> 
> [PATCH] 3c59x: Fix bad offset spec in skb_frag_dma_map

Tested 2 variants: only this patch (backported to old state) and both 
patches together.

Both work fine.

-- 
Meelis Roos (mroos@linux.ee)
