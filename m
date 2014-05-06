Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaEFROB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:14:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41580 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaEFRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:13:59 -0400
Date: Tue, 06 May 2014 13:13:54 -0400 (EDT)
Message-Id: <20140506.131354.1811745259385565455.davem@davemloft.net>
To: davej@redhat.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506162946.GA28261@redhat.com>
References: <20140506.113031.1577209312429629073.davem@davemloft.net>
	<20140506162946.GA28261@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 10:13:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Tue, 6 May 2014 12:29:46 -0400

> It seems like forever you go you sent me patches to trinity to make it
> work on sparc. I'm curious if you've tried running it again more
> recently ?   Given the work I've done it to do more creative things with
> VM related syscalls, I wouldn't be surprised if it also found some sparc
> specific bugs in thp.
> 
> It should now also scale up to run a lot more child processes than the older
> version, with the -c option, which could be interesting on some of the
> bigger sparc machines.
> 
> (It's entirely possible I've broken the compile on non-x86 in
>  current git, but it shouldn't be much work to fix up).
> 
> git://github.com/kernelslacker/trinity is where it lives now.

Thanks Dave, I'll take a look and get back to you.
