Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaAKRHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:07:55 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34290 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262AbaAKRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:07:50 -0500
Date: Sat, 11 Jan 2014 17:07:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/28] drm/i2c: tda998x: change probe message origin
Message-ID: <20140111170745.GQ15937@n2100.arm.linux.org.uk>
References: <20140109115827.18d0df97@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109115827.18d0df97@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:58:27AM +0100, Jean-Francois Moine wrote:
> This patch gives a more precise information about the device getting the
> TDA chip version.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

Please consider giving an example in the description of the old and new
in the above description.  In other words:

	armada-drm armada-510-drm: found TDA19988

becomes

	tda998x 0-0070: found TDA19988

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
