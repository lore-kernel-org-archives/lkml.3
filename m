Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaLPTnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:43:33 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56559 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLPTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:43:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arun.ramamurthy@broadcom.com, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, sbranden@broadcom.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, rjui@broadcom.com,
        Arun Ramamurthy <arunrama@broadcom.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        galak@codeaurora.org, grant.likely@linaro.org
Subject: Re: [PATCHv1] rtc: bcm-iproc: Add support for Broadcom iproc rtc
Date: Tue, 16 Dec 2014 20:42:56 +0100
Message-ID: <7947905.aK8KkUx4sY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418757750-3628-1-git-send-email-arun.ramamurthy@broadcom.com>
References: <1418757750-3628-1-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:sRqcuvSwlY6Ejm4ce83gfKoHGkHv/km4Yja67+pR5ngKDTDaOCn
 JvNK0xHxLOpt0Y2cxHn4EGsXVA2NGG+HRqtNjXfCoxnGQy/BOtZQus7yV+CBpt63X4UWzYh
 knxr9O6NdIlPjHfOw2FrZTloK5AbIcEoAzGbFzCeAE6DqjZ8lQldTfGCDu3V/nOS4c1+NaT
 leTCoL0zRjA1/7W23bWWQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2014 11:22:30 arun.ramamurthy@broadcom.com wrote:
> +       rtc: iproc_rtc@0x03026000 {
> +               compatible = "brcm,iproc-rtc";
> +               reg =   spru_bbl:               <0x03026000 0xC>,
> +                       crmu_pwr_good_status:   <0x0301C02C 0x14>,
> +                       crmu_bbl_auth:          <0x03024C74 0x8>;
> +               interrupts = spru_rtc_periodic: <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
> +                            spru_alarm:        <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>;

The reg properties look really random, could it be that the registers
are really part of some other device that contains multiple functions?

Also, what do you use the labels for?

	Arnd
