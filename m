Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaJGPhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:37:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187AbaJGPhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:37:06 -0400
Date: Tue, 7 Oct 2014 16:36:29 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Darshana Padmadas <darshanapadmadas@gmail.com>
Cc: "opw-kernel@googlegroups.com" <opw-kernel@googlegroups.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "jic23@kernel.org" <jic23@kernel.org>
Subject: Re: [PATCH v4 1/4] Documentation: devicetree: bindings: Document
 correct and deprecated vendor-prefix with device isl29028
Message-ID: <20141007153629.GC27216@leverpostej>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
 <1412695169-22815-2-git-send-email-darshanapadmadas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412695169-22815-2-git-send-email-darshanapadmadas@gmail.com>
Thread-Topic: [PATCH v4 1/4] Documentation: devicetree: bindings: Document
 correct and deprecated vendor-prefix with device isl29028
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darshana,

On Tue, Oct 07, 2014 at 04:19:26PM +0100, Darshana Padmadas wrote:
> This patch documents the device isl29028 with its vendor-prefix. Undocumented deprecated vendor-prefix
> found by checkpatch also documented for compatibility reasons.
> 
> Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>

In future, when you receive an Acked-by (or Reviewed-by, Tested-by,
etc), please add them here for subsequent postings, unless there have
been substantial changes that mean said tags are not representative. For
example, this patch you should have:

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>

That makes it obvious that others have looked at your patches, and will
help maintainers when deciding whether to pick them up. Additionally,
for those who have reviewed or tested patches, it gains them some
recognition for that effort.

Additionally, it's generally a good idea to wait for at least a day or
so between postings so as to give others time to inspect patches.

Thanks,
Mark.

> ---
>  Documentation/devicetree/bindings/i2c/trivial-devices.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index 6af570e..32edf0b 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -57,6 +57,8 @@ gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with Two-Wire In
>  infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max 100khz)
>  infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
>  isl,isl12057		Intersil ISL12057 I2C RTC Chip
> +isil,isl29028           (deprecated, use isl)
> +isl,isl29028            Intersil ISL29028 Ambient Light and Proximity Sensor
>  maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
>  maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
>  maxim,max6625		9-Bit/12-Bit Temperature Sensors with I²C-Compatible Serial Interface
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
