Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaHRRic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:38:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54875 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaHRRib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:38:31 -0400
Date: Mon, 18 Aug 2014 10:38:50 -0700 (PDT)
Message-Id: <20140818.103850.2072106996313096989.davem@davemloft.net>
To: aaro.koskinen@iki.fi
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com, cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140818173552.GA2126@drone.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
	<alpine.SOC.1.00.1408181528270.2922@math.ut.ee>
	<20140818173552.GA2126@drone.musicnaut.iki.fi>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Aug 2014 10:38:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Mon, 18 Aug 2014 20:35:52 +0300

> Hi,
> 
> On Mon, Aug 18, 2014 at 03:30:16PM +0300, Meelis Roos wrote:
>> > U1, U2, U5, U10, E220R, E420R later or some other day, whenever I get 
>> > to them physically.
>> 
>> Ultra 5 is bad news with 3.17-rc1: it almost boots up, then aftyer 
>> strarting postfix and ntpd, gets RED state exception and contiunes 
>> looping with it (before it gor RED state only after prom reboot).
> 
> My Ultra 5 is fine with 3.17-rc1 (I'm writing this mail from it),
> also Ultra 10 seems to be OK based on quick test.
> 
> I'm going to run GCC 4.9.1 bootstrap & testsuite on these machines
> maybe next week. Unfortunately due to summer schedules I'm a bit lost
> if there are still some special patches I should try (to get rid
> of $SUBJECT)? If not I'll probably try it with plain 3.17-rc2.

All patches are in 3,17-rc1

