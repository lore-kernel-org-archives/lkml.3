Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaFICNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 22:13:36 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:36169 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaFICNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 22:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com>
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com>
Date: Sun, 8 Jun 2014 23:13:29 -0300
Message-ID: <CAOMZO5Ceg9RpC8Lgt0BwGTuaz-Z2614Die2PrbtT_j4QYjL_sA@mail.gmail.com>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus information
From: Fabio Estevam <festevam@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        grygorii.strashko@ti.com, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@freescale.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 12:22 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Recently we introduced the generic device tree infrastructure for couple of DMA
> bus parameter, dma-ranges and dma-coherent. Update the documentation so that
> its useful for future users.
>
> The "dma-ranges" property is intended to be used for describing the
> configuration of DMA bus RAM addresses and its offset w.r.t CPU addresses.
>
> The "dma-coherent" property is intended to be used for identifying devices
> supported coherent DMA operations.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  Documentation/devicetree/booting-without-of.txt |   60 +++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
>
> diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
> index 1f013bd..f0120c1 100644
> --- a/Documentation/devicetree/booting-without-of.txt
> +++ b/Documentation/devicetree/booting-without-of.txt
> @@ -51,6 +51,8 @@ Table of Contents
>
>    VIII - Specifying device power management information (sleep property)
>
> +  VIV - Specifying dma bus information

"9" in Roman numeral is "IX"
