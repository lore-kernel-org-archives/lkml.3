Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3JCSJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:09:24 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61759 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3JCSJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <tip-e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf@git.kernel.org>
References: <1380644320-1026-1-git-send-email-teg@jklm.no>
	<tip-e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf@git.kernel.org>
Date: Thu, 3 Oct 2013 20:09:22 +0200
X-Google-Sender-Auth: ULaKHb_hm66x8iFQ-CzL2fPtXdI
Message-ID: <CAMuHMdV-fJ2F6Hus7CgUyCda6et7eR5Z2osZp-0MnWKrSwM+6w@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/simplefb: Fix overflow causing bogus fall-back
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 3:59 PM, tip-bot for Tom Gundersen
<tipbot@zytor.com> wrote:
> On my MacBook Air lfb_size is 4M, which makes the bitshit

bitshift?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
