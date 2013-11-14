Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3KNKTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:19:42 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:47506 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3KNKTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:19:40 -0500
Message-ID: <1384424280.9722.3.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v7 0/2] mmc: sdhci-msm: Add support for MSM chipsets
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org
Date: Thu, 14 Nov 2013 12:18:00 +0200
In-Reply-To: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Georgi,

On Wed, 2013-11-06 at 17:56 +0200, Georgi Djakov wrote: 
> This patchset adds basic support of the Secure Digital Host Controller
> Interface compliant controller found in Qualcomm MSM chipsets.
> 
> Tested with SD card on APQ8074 Dragonboard.

Thanks, Tested with mass-storage gadget :-). Forks fine.

Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Regards.

> 
> Georgi Djakov (2):
>   mmc: sdhci-msm: Initial SDHCI MSM driver documentation
>   mmc: sdhci-msm: Initial support for MSM chipsets
> 
>  .../devicetree/bindings/mmc/sdhci-msm.txt          |   93 +++
>  drivers/mmc/host/Kconfig                           |   13 +
>  drivers/mmc/host/Makefile                          |    1 +
>  drivers/mmc/host/sdhci-msm.c                       |  655 ++++++++++++++++++++
>  4 files changed, 762 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>  create mode 100644 drivers/mmc/host/sdhci-msm.c
> 


