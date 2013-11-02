Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3KBNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:09:26 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48586 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3KBNJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:09:21 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Matt Porter <matt.porter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 5/9] usb: gadget: s3c-hsotg: enable generic phy support
Date: Sat, 02 Nov 2013 14:09:21 +0100
Message-ID: <1868561.m5DoOTCY2U@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1383335158-19730-6-git-send-email-matt.porter@linaro.org>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org> <1383335158-19730-6-git-send-email-matt.porter@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt.

On Friday 01 of November 2013 15:45:54 Matt Porter wrote:
> Adds support for the generic PHY subsystem. Generic PHY
> support is probed and then the driver falls back to checking
> for an old style USB PHY and pdata if not found.
> 
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> ---
>  drivers/usb/gadget/s3c-hsotg.c | 54
> ++++++++++++++++++++++++++++-------------- 1 file changed, 36
> insertions(+), 18 deletions(-)

Patches that convert the driver to generic PHY have been already posted by 
Kamil Debski, as a part of a series[1] adding generic PHY drivers for S5P 
and Exynos SoCs. After that series, there will be no need to support the 
usb_phy subsystem in this driver anymore.

[1] http://www.mail-archive.com/linux-usb@vger.kernel.org/msg31189.html

Best regards,
Tomasz

