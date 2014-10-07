Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaJGPwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:52:04 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:35828 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbaJGPv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:51:57 -0400
Date: Tue, 7 Oct 2014 17:51:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-mips@linux-mips.org, linux-efi@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        Mark Rutland <mark.rutland@arm.com>, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org, lguest@lists.ozlabs.org,
        linux-c6x-dev@linux-c6x.org, linux-hexagon@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-acpi@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, xen-devel@lists.xenproject.org,
        devicetree@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, linux-pm@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-tegra@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, linux-metag@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, Rob Herring <robh+dt@kernel.org>,
        linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 07/44] qnap-poweroff: Drop reference to pm_power_off from
 devicetree bindings
Message-ID: <20141007155124.GB19005@lunn.ch>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-8-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412659726-29957-8-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 10:28:09PM -0700, Guenter Roeck wrote:
> Replace reference to pm_power_off (which is an implementation detail)
> and replace it with a more generic description of the driver's functionality.

Acked-by: Andrew Lunn <andrew@lunn.ch>

Thanks
	Andrew

> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt b/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
> index af25e77..1e2260a 100644
> --- a/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
> +++ b/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
> @@ -3,8 +3,8 @@
>  QNAP NAS devices have a microcontroller controlling the main power
>  supply. This microcontroller is connected to UART1 of the Kirkwood and
>  Orion5x SoCs. Sending the character 'A', at 19200 baud, tells the
> -microcontroller to turn the power off. This driver adds a handler to
> -pm_power_off which is called to turn the power off.
> +microcontroller to turn the power off. This driver installs a handler
> +to power off the system.
>  
>  Synology NAS devices use a similar scheme, but a different baud rate,
>  9600, and a different character, '1'.
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
