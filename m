Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaDVHbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:31:24 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64572 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaDVHbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <1398151791-24689-1-git-send-email-geert@linux-m68k.org>
References: <1398151791-24689-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 22 Apr 2014 09:31:18 +0200
X-Google-Sender-Auth: WnYOI8RHHPxRc2GLn0AULpTT3H4
Message-ID: <CAMuHMdUvj2T7vWJrQqtBrQRAxcooJT2q9kp5hRHMA_vKtqFadQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.15-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 9:29 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.15-rc2[1]  to v3.15-rc1[3], the summaries are:
>   - build errors: +4/-24

Nothing serious, just some known randconfig sound bits:

  + error: No rule to make target /etc/sound/dsp001.ld:  => N/A
  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: No rule to make target /etc/sound/trxpro.hex:  => N/A

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
