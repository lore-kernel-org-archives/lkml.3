Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967622AbaLLMQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:16:52 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57433 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966268AbaLLMQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:16:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ARM: mach-bcm: Enable PCIe support for iProc
Date: Fri, 12 Dec 2014 13:15:52 +0100
Message-ID: <3173848.p74DGitYxH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418351817-14898-4-git-send-email-rjui@broadcom.com>
References: <1418351817-14898-4-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:vt7mUxpM5rPVOXnl8JE3QorpwvFDvjB9ZF+koduLmKgehTqQ9Bj
 /kLQ3h4wFatHfVlaDh06UasfCddU+dmaaBbDpP8QxOYOxZtyf4pgrdbj2309obRifKI2FDb
 UecRGTxMisizZLtch96yRqcZ8cRtaiMXCzqTN4T7mrpDd0yfYU88O5MHdlxkFtPXd5ap77q
 5SFIIS96pJpqsznDTkIRg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 18:36:56 Ray Jui wrote:
> Enable PCIe driver support for Broadcom iProc family of SoCs by
> selecting PCIE_IPROC
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>
> ---
>  arch/arm/mach-bcm/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index aaeec78..a13a0b2 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -19,6 +19,7 @@ config ARCH_BCM_IPROC
>  	select ARCH_REQUIRE_GPIOLIB
>  	select ARM_AMBA
>  	select PINCTRL
> +	select PCIE_IPROC
>  	help
>  	  This enables support for systems based on Broadcom IPROC architected SoCs.
>  	  The IPROC complex contains one or more ARM CPUs along with common
> 

No, just enable it in multi_v7_defconfig and bcm_defconfig.

	Arnd
