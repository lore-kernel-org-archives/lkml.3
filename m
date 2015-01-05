Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbbAENXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:23:50 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35465 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbbAENXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:23:48 -0500
MIME-Version: 1.0
In-Reply-To: <3007073.i0ghnTEhxV@wasted.cogentembedded.com>
References: <3007073.i0ghnTEhxV@wasted.cogentembedded.com>
Date: Mon, 5 Jan 2015 14:23:46 +0100
X-Google-Sender-Auth: YJNqBFyFQGboaPNLkDPvT3fwmWs
Message-ID: <CAMuHMdUPyVxvVQPitJXOaqWC9_SPkzDUx+sg2mD2yHHZSyE=Xw@mail.gmail.com>
Subject: Re: [PATCH v2] clk-rcar-gen2: RCAN clock support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pavel Kiryukhin <vksavl@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Wed, Dec 24, 2014 at 11:17 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Add the RCAN clock support to the R-Car generation 2 CPG driver.  This clock
> gets derived from  the USB_EXTAL clock, dividing  it by 6.  The layout of the
> RCANCKCR register is similar to those of the clocks supported by the 'clk-div6'
> driver but has no divider field, and so can't be supported by that driver...

Thanks, looks fine to me.

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
