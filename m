Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaAKSv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:51:29 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34569 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753677AbaAKSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:51:21 -0500
Date: Sat, 11 Jan 2014 18:51:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 23/28] drm/i2c: tda998x: add the active aspect in
	HDMI AVI frame
Message-ID: <20140111185114.GK15937@n2100.arm.linux.org.uk>
References: <20140109120639.5f76c620@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120639.5f76c620@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:06:39PM +0100, Jean-Francois Moine wrote:
> This patch adds the active aspect as 'picture' in the HDMI AVI frame
> and also some comments about this frame.

Yes, this should've been set.  It's probably a stable tree candidate,
but first it needs testing.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
