Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab3BMMlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:41:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6077 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922Ab3BMMlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:41:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 13 Feb 2013 04:41:15 -0800
Message-ID: <511B89D6.7010000@nvidia.com>
Date: Wed, 13 Feb 2013 18:10:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 6/6] dma: tegra20-apb-dma: remove unnecessary assignment
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com> <1360666720-19006-7-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1360666720-19006-7-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013 04:28 PM, Andy Shevchenko wrote:
> There is no need to assign 0 to residue, because dma_cookie_status() does this
> for us.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---

For this change(6/6), Acked-by: Laxman Dewangan <ldewangan@nvidia.com>


