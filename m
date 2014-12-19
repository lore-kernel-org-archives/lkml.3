Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaLSTKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:10:36 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49981 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaLSTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:10:34 -0500
Message-ID: <54947827.5050104@gmail.com>
Date: Fri, 19 Dec 2014 11:10:31 -0800
From: Steve Longerbeam <slongerbeam@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 3/7] drm_modes: add videomode_from_drm_display_mode
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>	 <1418954426-21909-4-git-send-email-steve_longerbeam@mentor.com> <1418986984.3165.64.camel@pengutronix.de>
In-Reply-To: <1418986984.3165.64.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2014 03:03 AM, Philipp Zabel wrote:
>
> +EXPORT_SYMBOL_GPL(videomode_from_drm_display_mode);
> Is it ok for drm_modes to export a function that doesn't start with
> drm_ ? We could just rename this to drm_display_mode_to_videomode if
> necessary. I can fix it up as I apply it, but I'd like to know which is
> preferred.

Yeah, drm_display_mode_to_videomode() is probably better,
makes it more clear it's part of the DRM kernel interfaces.

Steve

