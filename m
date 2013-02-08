Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947260Ab3BHV5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:57:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37703 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947122Ab3BHV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:57:52 -0500
Date: Fri, 08 Feb 2013 16:57:48 -0500 (EST)
Message-Id: <20130208.165748.1764406121592777701.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, romieu@fr.zoreil.com,
        nic_swsd@realtek.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFx81-GGEEXx+MqJvwJsDoBMMqSN80=J8LmN-Ufu4+kKcw@mail.gmail.com>
References: <20130208.151713.1708597749091717933.davem@davemloft.net>
	<CA+55aFx81-GGEEXx+MqJvwJsDoBMMqSN80=J8LmN-Ufu4+kKcw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Feb 2013 08:00:39 +1100

> However, there's still the r8169 regressions (see the emails with the
> subject "regression: NETDEV WATCHDOG: eth0 (r8169): transmit queue 0
> timed out"). It's bisected, and a revert is reported to fix things.
> It's not in this pull request. Comments?

We're waiting for Hayes Wang, the author and the person most
knowledgable about those changes, to respond.

If I don't hear anything by next Weds I'll simply revert the
suspect changes.

