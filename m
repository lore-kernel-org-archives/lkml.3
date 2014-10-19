Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaJSHHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 03:07:12 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:34700 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaJSHHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 03:07:08 -0400
Date: Sun, 19 Oct 2014 10:07:03 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141019.003209.2286339581794609198.davem@davemloft.net>
Message-ID: <alpine.LRH.2.11.1410191006430.32417@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee> <20141015.231154.1804074463934900124.davem@davemloft.net> <alpine.LRH.2.11.1410170012130.19924@adalberg.ut.ee> <20141019.003209.2286339581794609198.davem@davemloft.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Meelis Roos <mroos@linux.ee>
> Date: Fri, 17 Oct 2014 00:38:20 +0300 (EEST)
> 
> > arch/sparc/kernel/setup_64.c is the only culprit.
> > 
> > Attached are 2 versions of the object file as of v3.17-rc1-22-g480cadc 
> > that I tested.
> 
> Just to confirm, a gcc-4.9 compiled kernel works if just setup_64.c
> is built with gcc-4.6, is that correct?

Yes, exactly.

-- 
Meelis Roos (mroos@linux.ee)
