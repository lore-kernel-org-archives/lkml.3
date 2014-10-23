Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaJWR2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:28:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42131 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJWR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:28:14 -0400
Date: Thu, 23 Oct 2014 13:02:58 -0400 (EDT)
Message-Id: <20141023.130258.548864295965807596.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410230221360.28745@adalberg.ut.ee>
References: <20141020.145746.428441452740929005.davem@davemloft.net>
	<20141022.163949.1761351331649936601.davem@davemloft.net>
	<alpine.LRH.2.11.1410230221360.28745@adalberg.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 10:28:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Thu, 23 Oct 2014 02:22:36 +0300 (EEST)

>> Whilst I don't have access to my reproducer machine until tomorrow in
>> order to test this myself, I wanted to toss this patch your way so you
>> could get a head start on me.
> 
> Unfortunately it fails earlier during the boot:
> 
> [   25.232318] clocksource: mult[53555555] shift[24]
> [   25.288559] clockevent: mult[3126e98] shift[32]
> [   25.342813] Console: colour dummy device 80x25
> [   25.395990] console [tty0] enabled
> [   25.436726] bootconsole [earlyprom0] disabled
> ERROR: Last Trap: Memory Address not Aligned
> 
> ok

I can reproduce and I know what the problem is, fixed patch coming up
shortly.

Thanks for all of your help so far!
