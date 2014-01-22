Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaAVVmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:42:04 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45764 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752786AbaAVVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:42:01 -0500
Date: Wed, 22 Jan 2014 21:41:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/24] drm/i2c: tda998x: fix a NULL pointer
	dereference
Message-ID: <20140122214154.GK15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195843.59810a46@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195843.59810a46@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:43PM +0100, Jean-Francois Moine wrote:
> This patch fixes a NULL pointer dereference when the set_config
> function has not been called (priv->params == NULL).

No, that's not what this patch is doing.  Maybe you could enlighten me
how priv->params could ever be NULL when that is _not_ a pointer?  That's
completely impossible as it isn't a pointer.

If you tried "priv->params = NULL" the C compiler would barf on it.

I suspect you've misunderstood the code, and this change isn't actually
necessary.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
