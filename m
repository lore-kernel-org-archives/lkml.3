Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHNMVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:21:46 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:50570 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaHNMVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:21:44 -0400
Date: Thu, 14 Aug 2014 15:20:38 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <20140813.124611.767426770013677.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1408141519440.24828@math.ut.ee>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee> <20140730.150722.861254999466992321.davem@davemloft.net> <alpine.SOC.1.00.1408131327250.18696@math.ut.ee> <20140813.124611.767426770013677.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Did not test current git more.
> 
> Current git fails to boot without this fix which I posted the other
> day:
> 
> ====================
> [PATCH 1/2] sparc64: Do not disable interrupts in nmi_cpu_busy()

Thanks, I noticed it on sparclinux@ but did not add one and one 
together. Now it seems to work with at least T2000. Will test other 
machines as I get some time.

-- 
Meelis Roos (mroos@linux.ee)
