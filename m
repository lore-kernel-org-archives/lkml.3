Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaAVX3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:29:33 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45851 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753618AbaAVX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:29:29 -0500
Date: Wed, 22 Jan 2014 23:29:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 19/24] drm/i2c: tda998x: use global constants
Message-ID: <20140122232922.GP15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195845.13b8a0e9@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195845.13b8a0e9@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:45PM +0100, Jean-Francois Moine wrote:
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Might be worth also saying "and tidy up AIP_CLKSEL" since arguably they
were already using global constants.  In any case, no one likes single
line patch descriptions.  Always try to write something more about the
patch.

I've verified this via inspection, and tested it.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
