Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaETR0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:26:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaETRZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:25:58 -0400
Message-ID: <537B9022.20709@wwwdotorg.org>
Date: Tue, 20 May 2014 11:25:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mmc: tegra: disable UHS modes
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org> <1397689719-28882-1-git-send-email-abrestic@chromium.org> <1397689719-28882-2-git-send-email-abrestic@chromium.org>
In-Reply-To: <1397689719-28882-2-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 05:08 PM, Andrew Bresticker wrote:
> Program TEGRA_SDHCI_VENDOR_MISC_CTRL so that UHS modes aren't advertised
> in SDHCI_CAPABILITIES_1.  While the Tegra SDHCI controller does support
> these modes, they require Tegra-specific tuning and calibration routines
> which the driver does not support yet.

What's the status of patches 1 and 2 in this series? I assumed they'd be
applied to the MMC tree. I've had them applied to my local development
tree for a while now, so in case this helps:

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

(I thought I wrote that before, but I can't find it, so I must have
forgotten to)
