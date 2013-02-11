Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3BKAHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:07:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60078 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3BKAHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:07:37 -0500
Date: Sun, 10 Feb 2013 19:07:33 -0500 (EST)
Message-Id: <20130210.190733.2188067351706209540.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hayeswang@realtek.com, jrg.otte@gmail.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130208225026.GA24672@electric-eye.fr.zoreil.com>
References: <20130208.151713.1708597749091717933.davem@davemloft.net>
	<CA+55aFx81-GGEEXx+MqJvwJsDoBMMqSN80=J8LmN-Ufu4+kKcw@mail.gmail.com>
	<20130208225026.GA24672@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Fri, 8 Feb 2013 23:50:26 +0100

> Linus Torvalds <torvalds@linux-foundation.org> :
> [...]
>> However, there's still the r8169 regressions (see the emails with the
>> subject "regression: NETDEV WATCHDOG: eth0 (r8169): transmit queue 0
>> timed out"). It's bisected, and a revert is reported to fix things.
>> It's not in this pull request. Comments ?
> 
> Jörg asked Hayes. Hayes suggested to revert. Francois reverts, fixes a
> pair of rejects, builds, boot. Anyone should be able to pull from
> branch 'davem.r8169' in repository
> 
> git://violet.fr.zoreil.com/romieu/linux davem.r8169

Now that Jörg has tested these reverts successfully, I've pulled
them into my tree, thanks everyone.
