Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3IICoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:44:25 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3048 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3IICoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:44:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 06 Sep 2013 05:07:14 -0700
Message-ID: <5229C9E9.6020001@nvidia.com>
Date: Fri, 6 Sep 2013 17:56:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
Subject: Re: [PATCH 1/1] dma: tegra20-apb-dma: Staticize tegra_dma_prep_dma_cyclic
References: <1378467982-30327-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1378467982-30327-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 September 2013 05:16 PM, Sachin Kamat wrote:
> tegra_dma_prep_dma_cyclic is referenced only in this file.
> Make it static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>
Agree, looks good.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
