Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaAVX1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:27:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45840 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752539AbaAVX1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:27:24 -0500
Date: Wed, 22 Jan 2014 23:27:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/24] drm/i2c: tda998x: fix the ENABLE_SPACE
	register
Message-ID: <20140122232716.GO15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195845.086be909@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195845.086be909@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:45PM +0100, Jean-Francois Moine wrote:
> This patch fixes the ENABLE_SPACE register, the value of which was
> inverted.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

I've researched the change to PLL_SERIAL_2, and this is correct.  I think
your change to REG_ENABLE_SPACE is also correct.  This looks like a bug
fix to me, so maybe consider having it applied to previous kernel
versions as well?

Also... please try putting yourself in the position of a reviewer of your
own patches - read the patch and then read the description, and ask whether
the description is adequate for the patch... the description talks just
about the ENABLE_SPACE register.  But what about the PLL_SERIAL_2 register
changes?  They're *totally* not described.

Hence...

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

and no acked-by.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
