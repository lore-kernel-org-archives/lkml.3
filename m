Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaHRRgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:36:03 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:32938 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaHRRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:36:01 -0400
Date: Mon, 18 Aug 2014 20:35:52 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Meelis Roos <mroos@linux.ee>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20140818173552.GA2126@drone.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee>
 <20140730.150722.861254999466992321.davem@davemloft.net>
 <alpine.SOC.1.00.1408131327250.18696@math.ut.ee>
 <20140813.124611.767426770013677.davem@davemloft.net>
 <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
 <alpine.SOC.1.00.1408181528270.2922@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1408181528270.2922@math.ut.ee>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 18, 2014 at 03:30:16PM +0300, Meelis Roos wrote:
> > U1, U2, U5, U10, E220R, E420R later or some other day, whenever I get 
> > to them physically.
> 
> Ultra 5 is bad news with 3.17-rc1: it almost boots up, then aftyer 
> strarting postfix and ntpd, gets RED state exception and contiunes 
> looping with it (before it gor RED state only after prom reboot).

My Ultra 5 is fine with 3.17-rc1 (I'm writing this mail from it),
also Ultra 10 seems to be OK based on quick test.

I'm going to run GCC 4.9.1 bootstrap & testsuite on these machines
maybe next week. Unfortunately due to summer schedules I'm a bit lost
if there are still some special patches I should try (to get rid
of $SUBJECT)? If not I'll probably try it with plain 3.17-rc2.

A.
