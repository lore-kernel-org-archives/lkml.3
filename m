Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaESFy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:54:27 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47916 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaESFyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:54:24 -0400
Date: Sun, 18 May 2014 22:54:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        nsekhar@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 7/7] Input: pixcir_i2c_ts: Add device tree support
Message-ID: <20140519055421.GF29386@core.coreip.homeip.net>
References: <1399374372-29123-1-git-send-email-rogerq@ti.com>
 <1399374372-29123-8-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399374372-29123-8-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:06:12PM +0300, Roger Quadros wrote:
> Provide device tree support and binding information.
> Also provide support for a new chip "pixcir_tangoc".
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  .../bindings/input/touchscreen/pixcir_i2c_ts.txt   | 26 ++++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  drivers/input/touchscreen/pixcir_i2c_ts.c          | 78 ++++++++++++++++++++++
>  3 files changed, 105 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt b/Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
> new file mode 100644
> index 0000000..0ab9505
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
> @@ -0,0 +1,26 @@
> +* Pixcir I2C touchscreen controllers
> +
> +Required properties:
> +- compatible: must be "pixcir,pixcir_ts" or "pixcir,pixcir_tangoc"
> +- reg: I2C address of the chip
> +- interrupts: interrupt to which the chip is connected
> +- attb-gpio: GPIO connected to the ATTB line of the chip
> +- x-size: horizontal resolution of touchscreen
> +- y-size: vertical resolution of touchscreen

There is a patch by Sebastian Reichel trying to unify touchscreen OF
properties, I think it would be nice if we used the same properties
here.

Thanks.

-- 
Dmitry
