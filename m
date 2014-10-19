Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaJSRMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:12:50 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:33380 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaJSRMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:12:46 -0400
Date: Sun, 19 Oct 2014 20:12:43 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: iamjoonsoo.kim@lge.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
        cl@linux.com, penberg@kernel.org, rientjes@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <alpine.LRH.2.11.1410191459210.32417@adalberg.ut.ee>
Message-ID: <alpine.LRH.2.11.1410192011410.32417@adalberg.ut.ee>
References: <20141016.165017.1151349565275102498.davem@davemloft.net> <alpine.LRH.2.11.1410171410210.25429@adalberg.ut.ee> <20141018.135907.356113264227709132.davem@davemloft.net> <20141018.142335.1935310766779155342.davem@davemloft.net>
 <alpine.LRH.2.11.1410191459210.32417@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I don't want to define the array size of the fpregs save area
> > > explicitly and thereby placing an artificial limit there.
> > 
> > Nevermind, it seems we have a hard limit of 7 FPU save areas anyways.
> > 
> > Meelis, please try this patch:
> 
> Works fine with 3.17.0-09670-g0429fbc + fault patch.
> 
> Will try current git next to find any new problems :)

Works on all 3 machines, with latest git (only had to apply the no-ipv6 
patch on one of them). Thank you for the good work!

-- 
Meelis Roos (mroos@linux.ee)
