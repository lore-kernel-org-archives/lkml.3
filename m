Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbaDPWt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:49:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48572 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaDPWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:49:25 -0400
Date: Wed, 16 Apr 2014 18:49:22 -0400 (EDT)
Message-Id: <20140416.184922.850531879281945129.davem@davemloft.net>
To: mroos@linux.ee
Cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1404170119550.20193@math.ut.ee>
References: <20140414184353.GA5630@drone.musicnaut.iki.fi>
	<20140416.145822.1317931249717152474.davem@davemloft.net>
	<alpine.SOC.1.00.1404170119550.20193@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Apr 2014 15:49:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mroos@linux.ee
Date: Thu, 17 Apr 2014 01:22:17 +0300 (EEST)

>> > Just for the archives, I got one of these again with 3.14:
>> 
>> Meelis and Aaro, thanks again for all of your reports.
>> 
>> After pouring over a lot of the data and auditing some code I'm
>> suspecting it's a problem with transparent huge pages.
>> 
>> One thing you two can do to help me further confirm this is to run
>> with THP disabled for a while and see if you still get the log
>> messages.
> 
> I have snice turned off CONFIG_TRANSPARENT_HUGEPAGE on 3 of 4 servers 
> that had this problem (actually most of my sparc64 machines) and the 4th 
> has
 ...
> and also has not had this problem since then. All 4 machines have been 
> running through most -rc's of every kernel.

Thanks this is a very useful datapoint.
