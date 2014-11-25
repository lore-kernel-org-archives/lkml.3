Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaKYMyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:54:10 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56890 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaKYMyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:54:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk,
        jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com,
        gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net,
        broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com,
        florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sprdlinux@freelists.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 2/5] Documentation: DT: Add bindings for Spreadtrum SoC Platform
Date: Tue, 25 Nov 2014 13:52:42 +0100
Message-ID: <2672926.PUHDU64fHa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416917818-10506-3-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1416917818-10506-3-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VnIgMJKsj/5z0OZo782u5rVGrsrrUrp84glAiRyYueC
 yOyLArp+5Q7Xw5DEFS3ZE5SAT7T/h18MU+P8HhVecL7KDj98B9
 iobSMuaFoxBZQn5KsKk6LAASspNRhfVtlUkG+hovXbIkVWML0G
 JFNXkebNiZQvkXDtK3wbs/6NPoFvT3atWeFUSQGuo0eSJPBGtl
 RWhAdzTKS5UlPIrNRfJYpXjRCPa6Q4c63+syZhbFVk/jvPmv98
 ZtmrAmSvfsfxNyxlcMEHqww7G4n9JAWRXRE5v65nOknqjy1lJh
 s2HW/nN1w+G5t3QmgrkmGtU0ESxdfZOcE2mCVlTJhfvXqBQGOE
 TwNcZ9w/RKa5sOPPmXFE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014 20:16:55 Chunyan Zhang wrote:
> diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.txt b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> new file mode 100644
> index 0000000..54e532f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> @@ -0,0 +1,6 @@
> +* Spreadtrum serial UART
> +
> +Required properties:
> +- compatible: must be "sprd,sc9836-uart"
> +- reg: offset and length of the register set for the device
> +- interrupts: exactly one interrupt specifier
> 

The driver uses a clock, and the dts file lists a clock
property, so it should be documented here, either as optional
or mandatory, and with a description what this clock refers to.

	Arnd
