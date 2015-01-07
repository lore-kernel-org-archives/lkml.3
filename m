Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbbAGS1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:27:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbbAGS1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:27:36 -0500
Message-ID: <1420655248.3191.73.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 07 Jan 2015 19:27:28 +0100
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.12.2014, 18:00 -0800 schrieb Steve Longerbeam:
> This patchset implements ->mode_fixup() in the imx ipuv3-crtc driver,
> using a new support function ipu_di_adjust_videomode(). This new
> function needs to be subsystem independent, so it accepts a video
> mode as a 'struct videomode'. Hence ipu-crtc ->mode_fixup() needs
> another support function to convert a drm_display_mode to a videomode
> before passing the mode to ipu_di_adjust_videomode() for fixup.
> 
> Also some related code cleanup: 'struct ipu_di_signal_cfg' should
> use 'struct videomode' for mode timings.

Alright, I have applied the series with
s/videomode_from_drm_display_mode/drm_display_mode_to_videomode/

thanks
Philipp

