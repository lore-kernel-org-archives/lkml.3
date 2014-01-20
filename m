Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaATEGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:06:13 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:44460 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaATEGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:06:10 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140119195844.0c975b90@armhf>
References: <cover.1390153344.git.moinejf@free.fr>
	<20140119195844.0c975b90@armhf>
Date: Sun, 19 Jan 2014 20:06:09 -0800
Message-ID: <CAOesGMi96wkHM8jfHNVnM7RJyW2vVoP6FT4YyYzKp-kfc0jTuQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/24] drm/i2c: tda998x: add DT documentation
From: Olof Johansson <olof@lixom.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 19, 2014 at 10:58 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  .../devicetree/bindings/drm/i2c/tda998x.txt        | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/drm/i2c/tda998x.txt

Please cc bindings for review to devicetree@vger.kernel.org (cc:d here now)

> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> new file mode 100644
> index 0000000..72da71d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> @@ -0,0 +1,24 @@
> +Device-Tree bindings for the NXP TDA998x HDMI transmitter
> +
> +Required properties;
> +  - compatible: must be "nxp,tda998x"
> +
> +Optional properties:
> +  - interrupts: interrupt number for HDMI exchanges - default: by polling

What are HDMI exchanges, and how do they differ from other interrupts?

> +
> +  - pinctrl-0: pin control group to be used for this controller (IRQ).
> +
> +  - pinctrl-names: must contain a "default" entry.
> +
> +  - video-ports: 24 bits value - default: <0x230145>

What is this?


-Olof
