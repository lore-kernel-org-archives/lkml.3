Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaLTPxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 10:53:16 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42362 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752448AbaLTPxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 10:53:12 -0500
Date: Sat, 20 Dec 2014 15:52:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 4/7] imx-drm: ipuv3-crtc: Implement mode_fixup
Message-ID: <20141220155254.GJ11285@n2100.arm.linux.org.uk>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
 <1418954426-21909-5-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418954426-21909-5-git-send-email-steve_longerbeam@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 06:00:23PM -0800, Steve Longerbeam wrote:
> Ask the IPU display interface, via ipu_di_adjust_videomode(), to
> adjust a video mode to meet any DI restrictions. The function takes
> a subsystem independent videomode, so the drm_display_mode must be
> converted to videomode first, and then the adjusted mode converted
> back to a drm_display_mode.

What is the reason to use videomode (apart from it being subsystem
independent)?  Do we forsee implementation of other output subsystems
for the IPU?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
