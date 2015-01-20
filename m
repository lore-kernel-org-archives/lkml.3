Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbbATLMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:12:53 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53735 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbbATLMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:12:50 -0500
Date: Tue, 20 Jan 2015 11:12:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 04/19] dt-binding: mfd: max77693: Add DT binding
 related macros
Message-ID: <20150120111243.GC13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-5-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420816989-1808-5-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2015, Jacek Anaszewski wrote:

> Add macros for max77693 led part related binding.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  include/dt-bindings/mfd/max77693.h |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 include/dt-bindings/mfd/max77693.h
> 
> diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
> new file mode 100644
> index 0000000..f53e197
> --- /dev/null
> +++ b/include/dt-bindings/mfd/max77693.h
> @@ -0,0 +1,21 @@
> +/*
> + * This header provides macros for MAX77693 device binding
> + *
> + * Copyright (C) 2014, Samsung Electronics Co., Ltd.
> + *
> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + */
> +
> +#ifndef __DT_BINDINGS_MAX77693_H__
> +#define __DT_BINDINGS_MAX77693_H
> +
> +/* External trigger type */
> +#define MAX77693_LED_TRIG_TYPE_EDGE	0
> +#define MAX77693_LED_TRIG_TYPE_LEVEL	1
> +
> +/* Boost modes */
> +#define MAX77693_LED_BOOST_OFF		0
> +#define MAX77693_LED_BOOST_ADAPTIVE	1
> +#define MAX77693_LED_BOOST_FIXED	2
> +
> +#endif /* __DT_BINDINGS_MAX77693_H */

These look fairly generic.  Do generic LED defines already exist?  If
not, can they?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
