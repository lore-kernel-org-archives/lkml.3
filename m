Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaLGGRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 01:17:34 -0500
Received: from smtp-69.nebula.fi ([83.145.220.69]:53632 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbaLGGRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 01:17:31 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2014 01:17:30 EST
Date: Sun, 7 Dec 2014 08:08:30 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Qiang Chen <qiang2.chen@sonymobile.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Chen <qcwj.lk@gmail.com>
Subject: Re: [PATCH] video: ocfb: Fix data type warning
Message-ID: <20141207060829.GA18983@chokladfabriken.org>
References: <1417767510-31462-1-git-send-email-qiang2.chen@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417767510-31462-1-git-send-email-qiang2.chen@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 04:18:30PM +0800, Qiang Chen wrote:
> When allocate framebuffer memory using dma_alloc_coherent(),
> we'd better use dma_addr_t instead of phys_addr_t. Because the
> address we got in fact is DMA or bus address for the platform.
> 
> This patch also fixes below build warning:
> drivers/video/fbdev/ocfb.c:335:2:
> 	warning: passing argument 3 of ‘dma_alloc_attrs’
> 	from incompatible pointer type [enabled by default]
> 
> Signed-off-by: Qiang Chen <qiang2.chen@sonymobile.com>

Acked-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
