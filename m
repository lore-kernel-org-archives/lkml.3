Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaAKRXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:23:33 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34322 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751274AbaAKRXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:23:30 -0500
Date: Sat, 11 Jan 2014 17:23:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 9/28] drm/i2c: tda998x: don't read write-only
	registers
Message-ID: <20140111172323.GV15937@n2100.arm.linux.org.uk>
References: <20140109115941.30e67a37@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109115941.30e67a37@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:59:41AM +0100, Jean-Francois Moine wrote:
> This patch takes care of the write-only registers of the tda998x.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

It would be worth commenting that where bit settings are unknown, they
are taken from the default values in the available public data.  I
refer to (for example) the addition of MAT_CONTRL_MAT_SC(1) to the
REG_MAT_CONTRL register in this patch.

The other register ordering changes should also be documented.

However, in my brief test, I haven't noticed any visible detrimental
effects.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
