Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab3FCEKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:10:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3FCEKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:10:13 -0400
X-AuditID: cbfee68f-b7f436d000000f81-48-51ac1723d1aa
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "'Shuah Khan'" <shuah.kh@samsung.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, rpurdie@rpsys.net, FlorianSchandinat@gmx.de,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com, Jingoo Han <jg1.han@samsung.com>
References: <1370128047-2444-1-git-send-email-shuah.kh@samsung.com>
In-reply-to: <1370128047-2444-1-git-send-email-shuah.kh@samsung.com>
Subject: Re: [PATCH v3] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Mon, 03 Jun 2013 13:10:10 +0900
Message-id: <001a01ce6010$3daaf3c0$b900db40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQK9QIxMUpghtMTMupkAiMbuzB1IwZdFnuOw
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zka6y+JpAgxO7JS3mrF/DZtE58xqj
	xeWFl1gtTvR9YLW4vGsOm8W6hy+YLB6veMtusXvXU1aLL5+5LL7+dLBYP/8WmwO3x85Zd9k9
	PnyM81i85yWTx6sLd1g8Tsz4zeKxZ/4PVo++LasYPY7f2M7k8XmTXABnFJdNSmpOZllqkb5d
	AlfGsZ66gpkCFdfbDBoYV/N2MXJySAiYSLzevoERwhaTuHBvPVsXIxeHkMAyRomDf3tYYIoW
	PZ3MCJFYxCixefdTdgjnF6PErscfmUGq2ATUJL58OQyU4OAQEQiROP0zEaSGWeAjo0T3tcVM
	IDVCAs4S598dZgOxOQVcJL4d/wa2WljAW6Jl7yo2kF4WAVWJ39esQcK8ApYSxx7PYoWwBSV+
	TL4HdhCzgJbE5m1NrBC2vMTmNW+ZIQ5VkNhx9jUjRFxEYt+Ld2C2iICRxModR5hB7pEQWMoh
	cXXbHXaQBIuAgMS3yYdYQPZKCMhKbDoANUdS4uCKGywTGCVmIVk9C8nqWUhWz0KybgEjyypG
	0dSC5ILipPQiY73ixNzi0rx0veT83E2MkCTQv4Px7gHrQ4zJQOsnMkuJJucDk0heSbyhsZmR
	hamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgPepaLv3yytjbg
	c1eiv8W039XbTp5QS1ub4f7YmLtvtd2z11t99zn7Za1Xs2KI447jLC+Zq2JlNI+fcf+OX9VN
	L2PMLt2YE++752xI6LkwvitzE87V/dK6vWVPzZvYxnb2Wn9GlvR37vu7/jb6yOccillhp/7T
	tNN8Z9sensUJe74u1bvXu1aJpTgj0VCLuag4EQB2HtZlGAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAV1l8TWBBlPPCFvMWb+GzaJz5jVG
	i8sLL7FanOj7wGpxedccNot1D18wWTxe8ZbdYveup6wWXz5zWXz96WCxfv4tNgduj52z7rJ7
	fPgY57F4z0smj1cX7rB4nJjxm8Vjz/wfrB59W1Yxehy/sZ3J4/MmuQDOqAZGm4zUxJTUIoXU
	vOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygY5UUyhJzSoFCAYnFxUr6
	dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGcd66gpmClRcbzNoYFzN28XIySEhYCKx6OlkRghb
	TOLCvfVsXYxcHEICixglNu9+yg7h/GKU2PX4IzNIFZuAmsSXL4eBEhwcIgIhEqd/JoLUMAt8
	ZJTovraYCaRGSMBZ4vy7w2wgNqeAi8S349/ANggLeEu07F3FBtLLIqAq8fuaNUiYV8BS4tjj
	WawQtqDEj8n3WEBsZgEtic3bmlghbHmJzWveMkMcqiCx4+xrRoi4iMS+F+/AbBEBI4mVO44w
	T2AUmoVk1Cwko2YhGTULSfsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEp5pnUDsaV
	DRaHGAU4GJV4eDu2rwoUYk0sK67MPcQowcGsJMKbvHJ1oBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnA9NfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	ymuyXrO/zXw47lKnSMqWa1+yFEILDj3jebFsua9colj7cqeI+HCPrhQm4z0LnorvUdTbahP3
	lv9txMsFz3g+xvL2fcgpMuqx2pfCx+pzv7qzs6jywYovM0MEDs2XPGi5edLe08AgDDkuGb/4
	kUCzbsl/tbN7PnQ5vL7JqBgusj+V++rVq2+VWIozEg21mIuKEwFs2rqWdQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 02, 2013 8:07 AM, Shuah Khan wrote:
> 
> Convert drivers/video/backlight/class to use dev_pm_ops for power
> management and remove Legacy PM ops hooks. With this change, backlight
> class registers suspend/resume callbacks via class->pm (dev_pm_ops)
> instead of Legacy class->suspend/resume. When __device_suspend() runs
> call-backs, it will find class->pm ops for the backlight class.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>

CC'ed Andrew Morton,

It looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
> 
> v2: Updated changelog to correct device class.
> v3: Updated changelog to correct device class.
> 
>  drivers/video/backlight/backlight.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index c74e7aa..0ffb251 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -208,7 +208,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
> 
>  static struct class *backlight_class;
> 
> -static int backlight_suspend(struct device *dev, pm_message_t state)
> +static int backlight_suspend(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> 
> @@ -236,6 +236,9 @@ static int backlight_resume(struct device *dev)
>  	return 0;
>  }
> 
> +static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
> +			 backlight_resume);
> +
>  static void bl_device_release(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> @@ -414,8 +417,7 @@ static int __init backlight_class_init(void)
>  	}
> 
>  	backlight_class->dev_attrs = bl_device_attributes;
> -	backlight_class->suspend = backlight_suspend;
> -	backlight_class->resume = backlight_resume;
> +	backlight_class->pm = &backlight_class_dev_pm_ops;
>  	return 0;
>  }
> 
> --
> 1.7.10.4
> 


