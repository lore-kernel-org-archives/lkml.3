Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaGBP1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:27:12 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51553 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752148AbaGBP1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:27:10 -0400
Date: Wed, 2 Jul 2014 16:27:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] drm/i2c: tda998x: Fix lack of required reg
	in DT documentation
Message-ID: <20140702152704.GL32514@n2100.arm.linux.org.uk>
References: <20140619104732.4ae7f6d3@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619104732.4ae7f6d3@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:47:32AM +0200, Jean-Francois Moine wrote:
> The I2C address (reg) is required for the TDA998x driver to be loaded
> and initialized.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> - v3
> 	- change subject to drm/i2c
> - v2
> 	- don't force the I2C address to be 0x70
> This patch applies to linux-next.

I had hoped that DT people would pick this up, as it's touching their
documentation.  However, it seems not, so I've added it to my fixes
queue, which I'll send RSN to David.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
