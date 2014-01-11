Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaAKRiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:38:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34350 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482AbaAKRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:38:23 -0500
Date: Sat, 11 Jan 2014 17:38:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/28] drm/i2c: tda998x: add DT support
Message-ID: <20140111173817.GZ15937@n2100.arm.linux.org.uk>
References: <20140109120324.4e2c8aca@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120324.4e2c8aca@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:03:24PM +0100, Jean-Francois Moine wrote:
> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> new file mode 100644
> index 0000000..f07339e1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> @@ -0,0 +1,16 @@
> +Device-Tree bindings for the NXP TDA998x HDMI transmitter
> +
> +Required properties;
> +  - compatible: must be "nxp,tda998x"
> +
> +Optional properties:
> +  - video-ports: 24 bits value - default: <0x230145>
> +
> +Example:
> +
> +	tda998x: hdmi-encoder {
> +		compatible = "nxp,tda998x";
> +		reg = <0x70>;
> +		pinctrl-0 = <&pmx_camera>;
> +		pinctrl-names = "default";

This example seems to be meaningless.  What SoC pinctrl settings are there
on this device?  What has a HDMI encoder got to do with a camera?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
