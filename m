Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaD1DdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:33:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36293 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaD1DdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:33:02 -0400
Date: Sun, 27 Apr 2014 23:33:00 -0400 (EDT)
Message-Id: <20140427.233300.1841871634019126565.davem@davemloft.net>
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, aaro.koskinen@iki.fi, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix several sparc64 THP bugs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1404262308350.3958@math.ut.ee>
References: <20140425.154337.1159533755150765063.davem@davemloft.net>
	<alpine.SOC.1.00.1404262308350.3958@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 27 Apr 2014 20:33:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mroos@linux.ee
Date: Sat, 26 Apr 2014 23:14:59 +0300 (EEST)

>> Meelis and Aaro, I've found and fixed several THP bugs for sparc64
>> over the last week or so.
>> 
>> I cannot %100 account for the exit_mmap() WARN_ON that you two have
>> been able to trigger, however I'd like you both to test the changes
>> nonetheless.
>> 
>> They are against 3.15 but they should apply cleanly all the way back
>> to 3.13
>> 
>> Thanks in advance for testing.
> 
> Tried it on Netra X1, Ultra 2 and V100 that were online (applied the 
> patches and enabled THP with defaulting to always).
> 
> Ultra 2 did not boot up (will see on Monday).
> 
> Netra X1 performed a simple dist-upgrade fine with this kernel.
> 
> V100 boots up fine but as soon as I start aptitude, it just hangs with 
> nothing on console (tried it twice).

Sigh, thanks for testing...
