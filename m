Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3EXPJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:09:10 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:55371 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3EXPJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:09:08 -0400
Message-ID: <519F829A.6070604@cogentembedded.com>
Date: Fri, 24 May 2013 19:09:14 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: myungjoo.ham@samsung.com, cw00.choi@samsung.com, balbi@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, lgirdwood@gmail.com,
        broonie@kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        gregkh@linuxfoundation.org, george.cherian@ti.com,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/3] drivers: regulator: palmas: add an API to set/clear
 the switch bit on SMPS10
References: <1369405896-30246-1-git-send-email-kishon@ti.com> <1369405896-30246-2-git-send-email-kishon@ti.com>
In-Reply-To: <1369405896-30246-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-05-2013 18:31, Kishon Vijay Abraham I wrote:

> From: Graeme Gregory <gg@slimlogic.co.uk>

> Added an API to set/clear the switch bit on SMPS10 which can be used by
> palmas usb. The switch bit should be set in order for palmas to
> supply VBUS and is needed when OMAP is acting as USB HOST.

> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   drivers/regulator/palmas-regulator.c | 26 ++++++++++++++++++++++++++
>   include/linux/mfd/palmas.h           |  2 ++
>   2 files changed, 28 insertions(+)

> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 92ceed0..d57ab55 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -465,6 +465,32 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
>   	return ret;
>   }
>
> +/**
> + * palmas_set_switch_smps10() - set or clear the switch bit on SMPS10
> + * @param palmas pointer to the palmas mfd structure
> + * @param sw boolean to indicate switch status

    Please follow the kernel-doc style described in 
Documentation/kernel-doc-nano-HOWTO.txt.

[...]

WBR, Sergei

