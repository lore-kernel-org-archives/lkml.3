Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaCGM5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:57:16 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48547 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaCGM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:57:14 -0500
MIME-Version: 1.0
In-Reply-To: <1394195775-25043-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394195775-25043-1-git-send-email-florian.vaussard@epfl.ch>
Date: Fri, 7 Mar 2014 13:57:14 +0100
X-Google-Sender-Auth: -hGtf6qb23hb2jdFpWLRf6c3Dg4
Message-ID: <CAMuHMdUmcnzafPhWrp4qYBB3UniFbVtqzNNg-7ed_Q6hZKMeDw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: dt: Reduce fragmentation of <..> placeholders
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Joe Perches <joe@perches.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 1:36 PM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> --- a/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
> @@ -2,7 +2,7 @@ Allwinner SoCs Watchdog timer
>
>  Required properties:
>
> -- compatible : should be "allwinner,<soc-family>-wdt", the currently supported
> +- compatible : should be "allwinner,<soc>-wdt", the currently supported
>    SoC families being sun4i and sun6i

"SoC families" is now "soc".

>  - reg : Specifies base physical address and size of the registers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
