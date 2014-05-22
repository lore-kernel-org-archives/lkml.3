Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaEVUlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:41:11 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47930 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEVUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <1400789482-5247-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1400789482-5247-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Date: Thu, 22 May 2014 22:41:08 +0200
X-Google-Sender-Auth: lxw43_fQReOSkGsj2xwb2lEs3UI
Message-ID: <CAMuHMdWmSMv2m1Re=EnmHJb=Sih3HdeUEHUQXSVeX-VZDjyF_w@mail.gmail.com>
Subject: Re: [PATCH v3] openrisc: irq: use irqchip framework
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux <linux@openrisc.net>, Jonas Bonn <jonas@southpole.se>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 10:11 PM, Stefan Kristiansson
<stefan.kristiansson@saunalahti.fi> wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
> @@ -0,0 +1,23 @@
> +OpenRISC 1000 Programmable Interrupt Controller
> +
> +Required properties:
> +
> +- compatible : should be "opencores,o1k-pic-level" for variants with

or1k

> +  level triggered interrupt lines, "opencores,o1k-pic-edge" for variants with

or1k

> +  edge triggered interrupt lines or "opencores,or1200-pic" for machines
> +  with the non-spec compliant or1200 type implementation.
> +
> +  "opencores,o1k-pic" is also provided as an alias to "opencores,or1200-pic",

or1k

> +  but this is only for backwards compatibility.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
