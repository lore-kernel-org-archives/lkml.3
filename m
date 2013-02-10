Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3BJJRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 04:17:18 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:40721 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3BJJRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 04:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130208225026.GA24672@electric-eye.fr.zoreil.com>
References: <20130208.151713.1708597749091717933.davem@davemloft.net>
	<CA+55aFx81-GGEEXx+MqJvwJsDoBMMqSN80=J8LmN-Ufu4+kKcw@mail.gmail.com>
	<20130208225026.GA24672@electric-eye.fr.zoreil.com>
Date: Sun, 10 Feb 2013 10:17:13 +0100
Message-ID: <CADDKRnB9dNkE4gL3de+F7bU5H3wQ47+3V3DH7Zeg-wjbOCB5ww@mail.gmail.com>
Subject: Re: [GIT] Networking
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/8 Francois Romieu <romieu@fr.zoreil.com>:
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
>
> to get the changes below :
>
> Distance from 'davem' (a1c83b054ebe1264ed9ae9d5c286f9eae68e60ea)
> ----------------------------------------------------------------
>
> 4521e1a94279ce610d3f9b7945c17d581f804242
> eef63cc1c6ecf4898a973f870aec95d6e923ea77
>
> Diffstat
> --------
>
>  drivers/net/ethernet/realtek/r8169.c | 86 ++++++++----------------------------
>  1 file changed, 19 insertions(+), 67 deletions(-)
>
> Shortlog
> --------
>
> Francois Romieu (2):
>       Revert "r8169: enable ALDPS for power saving".
>       Revert "r8169: enable internal ASPM and clock request settings".
>

Applied that patch on top of v3.8-rc7. Works well for me.

Thanks, Jörg
