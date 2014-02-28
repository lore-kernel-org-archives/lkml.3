Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaB1Usk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:48:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59905 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaB1Ush (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:48:37 -0500
Date: Fri, 28 Feb 2014 14:45:54 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v9 3/3] mmc: sdhci-msm: Add platform_execute_tunning
 implementation
Message-ID: <20140228204554.GI7308@joshc.qualcomm.com>
References: <1393586675-14628-1-git-send-email-gdjakov@mm-sol.com>
 <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nit below.

On Fri, Feb 28, 2014 at 01:24:35PM +0200, Georgi Djakov wrote:
> This patch adds implementation for platform specific tuning in order to support
> HS200 bus speed mode on Qualcomm SDHCI controller.
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  drivers/mmc/host/sdhci-msm.c |  424 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 418 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index b4490a2..69f6887 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
[..]
>  
> +int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)

This wants to be static.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
