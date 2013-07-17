Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3GQLvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:51:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52895 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3GQLvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:51:12 -0400
Message-ID: <51E684E3.2040104@ti.com>
Date: Wed, 17 Jul 2013 14:49:55 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linus.walleij@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/4] improved support for runtime muxing for pinctrl
References: <20130716090310.5541.36777.stgit@localhost>
In-Reply-To: <20130716090310.5541.36777.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 07/16/2013 12:05 PM, Tony Lindgren wrote:
> Hi all,
>
> As discussed earlier, the pinctrl support for changing some of the
> consumer device pins during runtime needs some improvment.
>
> Here are the patches to do that, I'll also post a minimal sample
> patch as a reply to this thread on how to do the muxing for
> runtime PM.

I've posted my patch and tested this patch series.
Seems everything is ok (except patch "pinctrl: Remove duplicate code in 
pinctrl_pm_select_state functions").
See http://www.spinics.net/lists/arm-kernel/msg259180.html

So,  Tested-By: Grygorii Strashko <grygorii.strashko@ti.com>

>
> Regards,
>
> Tony
>
> ---
>
> Tony Lindgren (4):
>        pinctrl: Remove duplicate code in pinctrl_pm_select_state functions
>        pinctrl: Allow pinctrl to have multiple active states
>        pinctrl: Add support for additional dynamic states
>        drivers: Add pinctrl handling for dynamic pin states
>
>
>   drivers/base/pinctrl.c                |   39 +++++
>   drivers/pinctrl/core.c                |  250 ++++++++++++++++++++++++++++-----
>   drivers/pinctrl/core.h                |   10 +
>   include/linux/pinctrl/consumer.h      |   46 ++++++
>   include/linux/pinctrl/devinfo.h       |    4 +
>   include/linux/pinctrl/pinctrl-state.h |   15 ++
>   6 files changed, 321 insertions(+), 43 deletions(-)
>

Regards,
-grygorii
