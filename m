Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaJOSga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:36:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53256 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJOSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:36:28 -0400
Date: Wed, 15 Oct 2014 14:36:24 -0400 (EDT)
Message-Id: <20141015.143624.941838991598108211.davem@davemloft.net>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410151059520.8050@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410150012001.11850@adalberg.ut.ee>
	<20141014.173246.921084057467310731.davem@davemloft.net>
	<alpine.LRH.2.11.1410151059520.8050@adalberg.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 11:36:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 15 Oct 2014 11:04:49 +0300 (EEST)

>> > My only other current sparc64 problems that I am seeing - V210/V440 die 
>> > during bootup if compiled with gcc 4.9 and V480 dies with FATAL 
>> > exceptions during bootups since previous kernel release. Maybe also 
>> > exit_mmap warning - I do not know if they have been fixed, I see them 
>> > rarely.
>> 
>> The gcc-4.9 case is interesting, are you saying that a gcc-4.9 compiled
>> kernel works fine on other systems?
> 
> Yes, all USII based systems work fine with Debian gcc-4.9, as does 
> T2000. Of USIII* systems, V210 and V440 exhibit the boot hang with 
> gcc-4.9 and V480 crashes wit FATAL exception during boot that is 
> probably earlier than the gcc boot hang so I do not know about V480 and 
> gcc-4.9. V240 not tested because of fan failures, V245 is in the queue 
> for setup but not tested so far.

Ok, on the V210/V440 can you boot with "-p" on the kernel boot command
line and post the log?  Let's start by seeing how far it gets, maybe
we can figure out roughly where it dies.

A boot hang should be relatively easy to diagnose and pinpoint.

Thanks.
