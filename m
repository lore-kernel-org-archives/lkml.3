Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3KCK35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 05:29:57 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62998 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3KCK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 05:29:55 -0500
MIME-Version: 1.0
In-Reply-To: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
References: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
Date: Sun, 3 Nov 2013 11:29:54 +0100
X-Google-Sender-Auth: Wpg775qpT27ZOJqJ5yw_VTfL6Ys
Message-ID: <CAMuHMdV-PXujh_vf_rwz7-bAi7wBaSL+9tWixvWnpWXr7skKZA@mail.gmail.com>
Subject: Re: [PATCH] Critical ARC Fix for 3.12
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CC stable, so Greg will see it.
Added commit 9c41f4eeb9d51f3ece20428d35a3ea32cf3b5622, so Greg knows
what to cherry-pick.

On Sat, Nov 2, 2013 at 1:17 PM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> Hi Linus,
>
> Sorry for this extemely late patch for 3.12 but it causes a SMP build of ARC
> to panic in boot.
>
> Greg, the patch as it is doesn't apply to 3.10 (but does to 3.11). So can you
> please queue it up for 3.11 and I'll send a fixup for 3.10.
>
> Thx,
> -Vineet
>
>
> Vineet Gupta (1):
>   ARC: Incorrect mm reference used in vmalloc fault handler
>
>  arch/arc/mm/fault.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
