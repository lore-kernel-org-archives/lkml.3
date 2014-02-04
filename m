Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaBDNTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:19:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36204 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaBDNTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:19:06 -0500
Message-ID: <52F0E8C6.5090006@codeaurora.org>
Date: Tue, 04 Feb 2014 08:19:02 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 0/3] mmc: sdhci-msm: Add support for Qualcomm chipsets
References: <1391107507-17321-1-git-send-email-gdjakov@mm-sol.com>
In-Reply-To: <1391107507-17321-1-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi,

On 01/30/2014 01:45 PM, Georgi Djakov wrote:
> This patchset adds basic support of the Secure Digital Host Controller
> Interface compliant controller found in Qualcomm chipsets.
> 
> Tested with eMMC and various micro SD cards on APQ8074 Dragonboard.

[...]

>  .../devicetree/bindings/mmc/sdhci-msm.txt          |   83 ++
>  drivers/mmc/host/Kconfig                           |   13 +
>  drivers/mmc/host/Makefile                          |    1 +
>  drivers/mmc/host/sdhci-msm.c                       |  938 ++++++++++++++++++++
>  4 files changed, 1035 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>  create mode 100644 drivers/mmc/host/sdhci-msm.c

You must have added entries to the Dragonboard device tree source to test
these changes. Why not include them with this patchset? Is there a stand-alone
patch that I've overlooked?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
