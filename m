Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaGNKap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:30:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50872 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaGNKag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:30:36 -0400
Message-ID: <53C3B138.2070006@ti.com>
Date: Mon, 14 Jul 2014 16:00:16 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org> <1405327664-27439-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1405327664-27439-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 14 July 2014 02:17 PM, Srinivas Kandagatla wrote:
> Hi Kishon,
> 
> First patch in this series adds support to the APQ8064 SATA PHY.
> Second patch updates the existing Kumar gala's device tree PHY bindings
> with APQ8064 soc specific compatible.
> 
> Eventhough there are two seperate drivers for both IPQ and APQ SOCs,
> the bindings are exactly same, so I did not create new bindings document.

Er.. create a separate binding.
> 
> Could you please pick these patches for v3.17.

Sure. please rebase to linux-phy next and re-send.

Thanks
Kishon
> 
> Changes since v2:
> 	- added usleep_range in poll timeout as discussed
> 		with Bartlomiej Zolnierkiewicz.
> 	- Added missing pdev_set_drvdata spotted by 
> 		Bartlomiej Zolnierkiewicz
> 
> Changes since v1:
> 	- included DT bindings in the series.
> 
> Thanks,
> srini
> 
> Srinivas Kandagatla (2):
>   phy: qcom: Add driver for QCOM APQ8064 SATA PHY
>   phy: qcom: Update APQ8064 PHY device tree bindings
> 
>  Documentation/devicetree/bindings/phy/qcom-phy.txt |   3 +-
>  drivers/phy/Kconfig                                |   7 +
>  drivers/phy/Makefile                               |   1 +
>  drivers/phy/phy-qcom-apq8064-sata.c                | 288 +++++++++++++++++++++
>  4 files changed, 298 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c
> 
