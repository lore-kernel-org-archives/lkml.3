Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaHHPus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:50:48 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39715 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaHHPuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <6429061.3nhKdDRquU@avalon>
References: <1407511931-26712-1-git-send-email-geert+renesas@glider.be>
	<6429061.3nhKdDRquU@avalon>
Date: Fri, 8 Aug 2014 17:50:44 +0200
X-Google-Sender-Auth: wGlBKOy0LtXFT1S_HlmRJwKKyhA
Message-ID: <CAMuHMdWHz_oF7+KeV3FbLeNdY9BoHwuuJoCdOvCSFcHdWFuMOQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pxav3: Remove unused variable in sdhci_pxav3_remove()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 5:38 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Thank you for the patch, but you're a bit too late :-)
>
> http://article.gmane.org/gmane.linux.kernel.mmc/28097

Doh, I'm not (yet) on linux-mmc.
It's a pity that fix is not yet in -next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
