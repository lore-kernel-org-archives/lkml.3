Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565Ab3GSN6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:58:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43770 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3GSN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:58:16 -0400
X-Auth-Info: p3fU2yNAYjrti3NUyX9ms8tLUdaKVXDfJuPXcdQdbjE=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v2 2/5] ARM: dts: add reference voltage property for MXS LRADC
Date: Fri, 19 Jul 2013 15:58:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-3-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374225208-28940-3-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307191558.17158.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Some LRADC channels have fixed pre-dividers so they can measure
> different voltages at full scale. The reference voltage allows to
> expose a scaling attribute through the IIO sysfs so that a user can
> compute the real voltage out of a measured sample value.
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---
>  Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt | 9
> ++++++++- arch/arm/boot/dts/imx23.dtsi                                   
> | 4 ++++ arch/arm/boot/dts/imx28.dtsi                                    |
> 4 ++++ 3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git
> a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt index
> 4688205..6ec485c 100644
> --- a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> +++ b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> @@ -1,9 +1,12 @@
>  * Freescale i.MX28 LRADC device driver
> 
>  Required properties:
> -- compatible: Should be "fsl,imx28-lradc"
> +- compatible: "fsl,imx28-lradc", "fsl,imx23-lradc"

This is a separate fix, but I think it's not that important to rework the whole 
patchset because of it.

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
