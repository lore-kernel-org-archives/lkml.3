Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaK2TF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 14:05:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41315 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaK2TFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 14:05:54 -0500
Date: Sat, 29 Nov 2014 20:05:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v8 12/14] leds: Add driver for AAT1290 current
 regulator
Message-ID: <20141129190550.GA17355@amd>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-13-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417166286-27685-13-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> @@ -0,0 +1,472 @@
> +/*
> + *	LED Flash class driver for the AAT1290
> + *	1.5A Step-Up Current Regulator for Flash LEDs
> + *
> + *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +

> +#define AAT1290_MM_TO_FL_1_92	1
> +#define AAT1290_MM_TO_FL_3_7	2
> +#define AAT1290_MM_TO_FL_5_5	3
> +#define AAT1290_MM_TO_FL_7_3	4
> +#define AAT1290_MM_TO_FL_9	5
> +#define AAT1290_MM_TO_FL_10_7	6
> +#define AAT1290_MM_TO_FL_12_4	7
> +#define AAT1290_MM_TO_FL_14	8
> +#define AAT1290_MM_TO_FL_15_9	9
> +#define AAT1290_MM_TO_FL_17_5	10
> +#define AAT1290_MM_TO_FL_19_1	11
> +#define AAT1290_MM_TO_FL_20_8	12
> +#define AAT1290_MM_TO_FL_22_4	13
> +#define AAT1290_MM_TO_FL_24	14
> +#define AAT1290_MM_TO_FL_25_6	15
> +#define AAT1290_MM_TO_FL_OFF	16

Only one of these defines is unused.

> +static struct of_device_id aat1290_led_dt_match[] = {

> +	{.compatible = "skyworks,aat1290"},

spaces after { and before } ?

Otherwise looks ok, 

Signed-off-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
