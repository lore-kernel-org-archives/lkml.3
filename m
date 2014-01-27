Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaA0UBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:01:18 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50213 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753657AbaA0UBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:01:17 -0500
Date: Mon, 27 Jan 2014 20:01:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/24] drm/i2c: tda998x: check the CEC device
	creation
Message-ID: <20140127200112.GX15937@n2100.arm.linux.org.uk>
References: <cover.1390646891.git.moinejf@free.fr> <20140125181443.7981862e@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125181443.7981862e@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 06:14:43PM +0100, Jean-Francois Moine wrote:
> This patch checks if the CEC device is well created at intialization
> time.
> 
> Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
