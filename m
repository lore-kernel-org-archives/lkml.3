Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbbAGITw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:19:52 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:37170 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbbAGITu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:19:50 -0500
MIME-Version: 1.0
In-Reply-To: <355163371.fkynKV0U5x@wasted.cogentembedded.com>
References: <355163371.fkynKV0U5x@wasted.cogentembedded.com>
Date: Wed, 7 Jan 2015 09:19:48 +0100
X-Google-Sender-Auth: ms2eJfSIa4ER8C2y1VSpeU7wX2o
Message-ID: <CAMuHMdUui=Ucjo-dxtjkBF2faF4mbvV4EAAT+CyZ_2ix9Nxp+Q@mail.gmail.com>
Subject: Re: [PATCH v3 resend] clk-rcar-gen2: ADSP clock support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 11:39 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Add the ADSP clock support to the R-Car generation 2 CPG driver.  This clock
> gets derived from  PLL1.  The layout of the ADSPCKCR register is  similar to
> those of the clocks supported by the 'clk-div6' driver but the divider encoding
> is non-linear, so can't be supported by that driver...
>
> Based on the original patch by Konstantin Kozhevnikov
> <konstantin.kozhevnikov@cogentembedded.com>.
>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
