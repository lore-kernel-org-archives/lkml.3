Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaFNWcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:32:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47052 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaFNWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:32:20 -0400
Date: Sun, 15 Jun 2014 00:31:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, ajitpal.singh@st.com, edubezval@gmail.com,
        rui.zhang@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com
Subject: Re: [PATCH 2/6] thermal: sti: Introduce ST Thermal core code
Message-ID: <20140614223156.GC1389@xo-6d-61-c0.localdomain>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
 <1401980819-19962-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401980819-19962-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-05 16:06:55, Lee Jones wrote:
> This core is shared by both ST's 'memory mapped' and
> 'system configuration register' based Thermal controllers.
> 
> Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Pavel Machek <pavel@ucw.cz>



> +++ b/drivers/thermal/st/st_thermal.c
> @@ -0,0 +1,313 @@
> +/*
> + * ST Thermal Sensor Driver core routines
> + * Author: Ajit Pal Singh <ajitpal.singh@st.com>
> + *
> + * Copyright (C) 2003-2014 STMicroelectronics (R&D) Limited
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +
> +#include "st_thermal.h"
...
> +/* Callback to get temperature from HW*/

Add space before */, but feel free to do it in followup patch.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
