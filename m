Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaHRMb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:31:26 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:34373 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaHRMbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:31:24 -0400
Date: Mon, 18 Aug 2014 15:30:16 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1408181528270.2922@math.ut.ee>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee> <20140730.150722.861254999466992321.davem@davemloft.net> <alpine.SOC.1.00.1408131327250.18696@math.ut.ee> <20140813.124611.767426770013677.davem@davemloft.net>
 <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> U1, U2, U5, U10, E220R, E420R later or some other day, whenever I get 
> to them physically.

Ultra 5 is bad news with 3.17-rc1: it almost boots up, then aftyer 
strarting postfix and ntpd, gets RED state exception and contiunes 
looping with it (before it gor RED state only after prom reboot).

ntpd.

RED State Exception

TL=0000.0000.0000.0005 TT=0000.0000.0000.0064
   TPC=0000.0000.0042.4c80 TnPC=0000.0000.0042.4c84 TSTATE=0000.0000.1104.1407
TL=0000.0000.0000.0004 TT=0000.0000.0000.0064
   TPC=0000.0000.0042.4c80 TnPC=0000.0000.0042.4c84 TSTATE=0000.0000.1104.1407
TL=0000.0000.0000.0003 TT=0000.0000.0000.0064
   TPC=0000.0000.0042.4c80 TnPC=0000.0000.0042.4c84 TSTATE=0000.0000.1104.1407
TL=0000.0000.0000.0002 TT=0000.0000.0000.0064
   TPC=0000.0000.0042.0c80 TnPC=0000.0000.0042.0c84 TSTATE=0000.0000.1104.1407
TL=0000.0000.0000.0001 TT=0000.0000.0000.0064
   TPC=0000.0000.0044.8580 TnPC=0000.0000.0044.8584 TSTATE=0000.0000.1100.1607


RED State Exception

TL=0000.0000.0000.0005 TT=0000.0000.0000.0064
   TPC=0000.0000.f000.4c80 TnPC=0000.0000.f000.4c84 TSTATE=0000.0044.5604.1400
TL=0000.0000.0000.0004 TT=0000.0000.0000.0064
   TPC=0000.0000.f000.4c80 TnPC=0000.0000.f000.4c84 TSTATE=0000.0044.5604.1400
TL=0000.0000.0000.0003 TT=0000.0000.0000.0064
   TPC=0000.0000.f000.4c80 TnPC=0000.0000.f000.4c84 TSTATE=0000.0044.5604.1400
TL=0000.0000.0000.0002 TT=0000.0000.0000.0064
   TPC=0000.0000.f000.0c80 TnPC=0000.0000.f000.0c84 TSTATE=0000.0044.5604.1400
TL=0000.0000.0000.0001 TT=0000.0000.0000.0064
   TPC=0000.0000.f000.3a00 TnPC=0000.0000.f000.3a04 TSTATE=0000.0044.5600.0400



-- 
Meelis Roos (mroos@linux.ee)
