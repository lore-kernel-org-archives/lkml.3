Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420Ab3BHVBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:01:05 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:42861 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760370Ab3BHVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130208.151713.1708597749091717933.davem@davemloft.net>
References: <20130208.151713.1708597749091717933.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Feb 2013 08:00:39 +1100
X-Google-Sender-Auth: VF63Rr39hIr-UYRf-GtkeZGh4Hc
Message-ID: <CA+55aFx81-GGEEXx+MqJvwJsDoBMMqSN80=J8LmN-Ufu4+kKcw@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pulled.

However, there's still the r8169 regressions (see the emails with the
subject "regression: NETDEV WATCHDOG: eth0 (r8169): transmit queue 0
timed out"). It's bisected, and a revert is reported to fix things.
It's not in this pull request. Comments?

               Linus

On Sat, Feb 9, 2013 at 7:17 AM, David Miller <davem@davemloft.net> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
>
> for you to fetch changes up to a1c83b054ebe1264ed9ae9d5c286f9eae68e60ea:
