Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaD1MmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:42:00 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:57798 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaD1Ml6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:41:58 -0400
Date: Mon, 28 Apr 2014 15:41:55 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, aaro.koskinen@iki.fi, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix several sparc64 THP bugs.
In-Reply-To: <20140427.233300.1841871634019126565.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1404281526190.1407@math.ut.ee>
References: <20140425.154337.1159533755150765063.davem@davemloft.net> <alpine.SOC.1.00.1404262308350.3958@math.ut.ee> <20140427.233300.1841871634019126565.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Meelis and Aaro, I've found and fixed several THP bugs for sparc64
> >> over the last week or so.
> >> 
> >> I cannot %100 account for the exit_mmap() WARN_ON that you two have
> >> been able to trigger, however I'd like you both to test the changes
> >> nonetheless.
> >> 
> >> They are against 3.15 but they should apply cleanly all the way back
> >> to 3.13
> >> 
> >> Thanks in advance for testing.
> > 
> > Tried it on Netra X1, Ultra 2 and V100 that were online (applied the 
> > patches and enabled THP with defaulting to always).
> > 
> > Ultra 2 did not boot up (will see on Monday).

When I rebooted it, the hang is not reproducible - Debian dist-upgrade 
went well. However, it is still strange.

-- 
Meelis Roos (mroos@linux.ee)
