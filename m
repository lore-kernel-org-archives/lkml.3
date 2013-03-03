Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3CCEW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 23:22:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3CCEWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 23:22:25 -0500
Date: Sat, 02 Mar 2013 23:22:24 -0500 (EST)
Message-Id: <20130302.232224.1317914733957734355.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] another embarrassing braino fix in signal.git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130303031056.GK4503@ZenIV.linux.org.uk>
References: <20130303031056.GK4503@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 02 Mar 2013 20:22:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 3 Mar 2013 03:10:56 +0000

> 	generic compat_sys_rt_sigprocmask() had a very dumb braino; I'd
> spent quite a while staring at the offending commit before finally managing
> to spot the idiocy ;-/  Dave, could you verify that it fixes all the problems
> you've seen on sparc?  FWIW, the symptoms I'd been seeing got fixed by that
> and AFAICS your reproducer is also taken care of.  The fix is definitely
> needed; the only question is if there's something else going on.  Linus,
> please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Yep, it fixed my problems, thanks Al.
