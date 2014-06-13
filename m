Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaFMOXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:23:41 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62223 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaFMOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:23:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Enable XADC driver
Date: Fri, 13 Jun 2014 16:22:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <1401984324-6075-1-git-send-email-soren.brinkmann@xilinx.com> <1401984324-6075-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1401984324-6075-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201406131622.54169.arnd@arndb.de>
X-Provags-ID: V02:K0:cOSD8CU12h2eBYlU15izZxtpW2wSld0WL9daueTd51b
 PnMoMwkvwADzQowzhbQKPByd4niCw0iFJqFDrWo1EpD197PP4H
 QLJBDK8p6I+HpMK7F0BHFrJPOcnAN8rLdipLsa0r+XUZPo9xDM
 QdAmfKbXqvicCZbY3wIoM6O1NoVRk2RCAE2DMtloM8a24fFvcb
 876iFO2+LWqV7R3wFzAEOPqosLwCGZ35R3ngx9LeF1DzEkfpuz
 C+XNJpoxgBkDnRd5eqshdDzyQIGK1J7W+XmTLxo8V50x13IHEV
 dSc8SEmZ6rkrTR+IqT8n1xrNYVKktueDPa9hNyKVXBKVTk9NWt
 /hmHCPH2yPUybgpwj/4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2014, Soren Brinkmann wrote:
> The Xilinx A/D Converter is found in Xilinx devices including Zynq.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index e2d62048e198..2d1039d8c7f1 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -360,6 +360,7 @@ CONFIG_TEGRA_IOMMU_GART=y
>  CONFIG_TEGRA_IOMMU_SMMU=y
>  CONFIG_MEMORY=y
>  CONFIG_IIO=y
> +CONFIG_XILINX_XADC=y
>  CONFIG_AK8975=y
>  CONFIG_PWM=y
>  CONFIG_PWM_TEGRA=y
> -- 

Applied both to fixes branch.

	Arnd
