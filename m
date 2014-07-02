Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaGBFR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:17:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58643 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaGBFRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:17:24 -0400
Message-ID: <53B3957B.40006@ti.com>
Date: Wed, 2 Jul 2014 10:45:39 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>, Tero Kristo <t-kristo@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 0/6] regulator: palmas: cleanup and fixes
References: <1404143859-8160-1-git-send-email-nm@ti.com>
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2014 09:27 PM, Nishanth Menon wrote:
> Hi,
> 	Original thread (v1): http://marc.info/?t=140380766500004&r=1&w=2
> This series is based on: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
> branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)
>
> This series does a few cleanups to help ensure we dont make typo mistakes and finally provides a fix as attempted by (v1).
>
> Basic cpufreq tests performed on OMAP5uEVM, DRA7-evm, DRA72-evm all of which are palmas variants.
>
> The patches are also available here: https://github.com/nmenon/linux-2.6-playground/commits/broonie-topic-palmas-fixes
> 		
For the series:

  Acked-by: Keerthy <j-keerthy@ti.com>
>       
> Nishanth Menon (6):
>    regulator: palmas: Squelch sparse warnings
>    regulator: palmas: Rename reg_info to palmas_reg_info
>    regulator: palmas: Simplify code by using pointer to palmas_reg_info
>    regulator: palmas: Rename palmas_regs_info to
>      palmas_generic_regs_info
>    regulator: palmas: Simplify code by not indexing regulator_desc
>      unnecessarily
>    regulator: palmas: Fix SMPS enable/disable/is_enable for tps65917
>
>   drivers/regulator/palmas-regulator.c |  344 ++++++++++++++++------------------
>   include/linux/mfd/palmas.h           |    4 +-
>   2 files changed, 166 insertions(+), 182 deletions(-)
>

