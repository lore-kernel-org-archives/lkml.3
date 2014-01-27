Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaA0UUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:20:22 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50226 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751843AbaA0UUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:20:21 -0500
Date: Mon, 27 Jan 2014 20:20:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/24] drm/i2c: tda998x: use irq for connection
	status and EDID read
Message-ID: <20140127202012.GZ15937@n2100.arm.linux.org.uk>
References: <cover.1390646891.git.moinejf@free.fr> <20140125181438.1353afc7@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125181438.1353afc7@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 06:14:38PM +0100, Jean-Francois Moine wrote:
> This patch adds the optional treatment of the tda998x IRQ.
> 
> The interrupt function is used to know the display connection status
> without polling and to speedup reading the EDID.
> 
> The IRQ number is defined in the i2c client either by platform data or
> in the DT.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

I don't see where you free the interrupt in this - you used to, but it
appears that hunk got dropped?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
