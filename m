Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbbAGJmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:42:36 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:61578 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbbAGJmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <1420599537-28740-2-git-send-email-walter@vanguardiasur.com.ar>
References: <1420599537-28740-1-git-send-email-walter@vanguardiasur.com.ar>
	<1420599537-28740-2-git-send-email-walter@vanguardiasur.com.ar>
Date: Wed, 7 Jan 2015 10:42:31 +0100
X-Google-Sender-Auth: xXXC82k68MJsqncbtEZrrtLx1VQ
Message-ID: <CAMuHMdVfqzTf034vyDPEYrnZ7+3iE+h2H+7Cs-ifJrePDrw-rg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: adxl34x - add device tree documentation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Walter Lozano <walter@vanguardiasur.com.ar>
Cc: michael.hennerich@analog.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 3:58 AM, Walter Lozano
<walter@vanguardiasur.com.ar> wrote:
> diff --git a/Documentation/devicetree/bindings/input/adxl34x.txt b/Documentation/devicetree/bindings/input/adxl34x.txt
> new file mode 100644
> index 0000000..0774f7e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/adxl34x.txt
> @@ -0,0 +1,53 @@
> +Device Tree bindings for adxl34x digital accelerometer, both spi and i2c.
> +
> +Depending on the interface this node should be a child of a spi or i2c bus.
> +
> +Required properties:
> +- compatible: "adxl34x"

"adi,adxl34x"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
