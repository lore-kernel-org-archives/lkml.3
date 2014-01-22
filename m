Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaAVVVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:21:23 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45719 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752408AbaAVVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:21:22 -0500
Date: Wed, 22 Jan 2014 21:21:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/24] drm/i2c: tda998x: check more I/O errors
Message-ID: <20140122212107.GF15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195838.348f8d6d@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195838.348f8d6d@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:38PM +0100, Jean-Francois Moine wrote:
> This patch adds more error checking inn I2C I/O functions.
> In case of I/O error, this permits to avoid writing in bad controller
> pages, a bad chipset detection or looping when getting the EDID.
> 
> Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
