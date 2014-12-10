Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaLJI46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:56:58 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:35741 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaLJI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:56:57 -0500
MIME-Version: 1.0
In-Reply-To: <3558682.jkN2tlsPNy@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
	<3558682.jkN2tlsPNy@wuerfel>
Date: Wed, 10 Dec 2014 09:56:55 +0100
X-Google-Sender-Auth: fv5BN35GSFyX87HfEMLHyywR_3A
Message-ID: <CAMuHMdW35QRFmTMvtfx_1ZHn1W8a_LMPFFWuZgtXGfKEQDddzQ@mail.gmail.com>
Subject: Re: [GIT PULL 8/9] ARM: SoC defconfig changes for 3.19
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Dec 9, 2014 at 10:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
>
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig-for-linus

On https://git.kernel.org/cgit/linux/kernel/git/arm/arm-soc.git/, the
"Download" column for all tags shows "tag <abbrev>...".
Clicking on any of them gives e.g.:

    https://git.kernel.org/cgit/linux/kernel/git/arm/arm-soc.git/tag/?id=066ae43e621090340384ab3751b68306c49cd503
    Bad tag reference: 066ae43e621090340384ab3751b68306c49cd503

In other repositories
(e.g. http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/), the
"Download" column for tags shows "commit <abbrev>...", and the links behind
them do work.

Note that if I s/tag/commit/ in the URL, it does work.

Is this an issue with your repository? Or does cgit on kernel.org needs to
be updated for a new feature?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
