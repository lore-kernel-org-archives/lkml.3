Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaL3WQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:16:01 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45718 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751939AbaL3WP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:15:59 -0500
Date: Wed, 31 Dec 2014 00:15:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 07/19] dt-binding: mfd: max77693: Add DT binding
 related macros
Message-ID: <20141230221522.GO17565@valkosipuli.retiisi.org.uk>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417622814-10845-8-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

The driver depends on these so I'd rearrange this patch in the set before
the driver patch.

On Wed, Dec 03, 2014 at 05:06:42PM +0100, Jacek Anaszewski wrote:
> Add macros for max77693 led part related binding.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  include/dt-bindings/mfd/max77693.h |   38 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 include/dt-bindings/mfd/max77693.h
> 
> diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
> new file mode 100644
> index 0000000..4011cb47
> --- /dev/null
> +++ b/include/dt-bindings/mfd/max77693.h
> @@ -0,0 +1,38 @@
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
> +/* External control pins */
> +#define MAX77693_LED_FLED_UNUSED	0
> +#define MAX77693_LED_FLED_USED		1
> +
> +/* FLED pins */
> +#define MAX77693_LED_FLED1		1
> +#define MAX77693_LED_FLED2		2

I'd personally simply use numbers for the above but I can't really say to be
an expert on the topic.

> +/* External trigger type */
> +#define MAX77693_LED_TRIG_TYPE_EDGE	0
> +#define MAX77693_LED_TRIG_TYPE_LEVEL	1
> +
> +/* Trigger flags */
> +#define MAX77693_LED_TRIG_FLASHEN	(1 << 0)
> +#define MAX77693_LED_TRIG_TORCHEN	(1 << 1)
> +#define MAX77693_LED_TRIG_SOFTWARE	(1 << 2)
> +
> +#define MAX77693_LED_TRIG_ALL		(MAX77693_LED_TRIG_FLASHEN | \
> +					 MAX77693_LED_TRIG_TORCHEN | \
> +					 MAX77693_LED_TRIG_SOFTWARE)
> +
> +/* Boost modes */
> +#define MAX77693_LED_BOOST_OFF		0
> +#define MAX77693_LED_BOOST_ADAPTIVE	1
> +#define MAX77693_LED_BOOST_FIXED	2
> +
> +#endif /* __DT_BINDINGS_MAX77693_H */

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
