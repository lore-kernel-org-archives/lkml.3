Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab3E1Fiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 01:38:51 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37911 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab3E1Fiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 01:38:50 -0400
Message-ID: <51A442E4.90307@linaro.org>
Date: Tue, 28 May 2013 11:08:44 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: kgene.kim@samsung.com, mturquette@linaro.org, thomas.abraham@linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 0/2] Clock changes for supporting CPUFreq on Exynos5250
References: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 11:25 AM, Tushar Behera wrote:
> With the use of common clock framework, CPUFreq driver on EXYNOS5250 now
> requires a few changes in clocks.
> 
> Tested on Exynos5250 based Arndale board.
> The patches are based on v3.10-rc1.
> 
> Tushar Behera (2):
>   clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
>   clk: exynos5250: Add sclk_mpll to the parent list of mout_cpu clock
> 
>  drivers/clk/samsung/clk-exynos5250.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Any comments on this series?

-- 
Tushar Behera
