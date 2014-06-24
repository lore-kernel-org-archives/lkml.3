Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaFXKC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:02:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39951 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751855AbaFXKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:02:55 -0400
Date: Tue, 24 Jun 2014 11:02:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>, gnurou@gmail.com,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
Message-ID: <20140624100220.GK32514@n2100.arm.linux.org.uk>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com> <1403603667-11302-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403603667-11302-3-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 06:54:26PM +0900, Alexandre Courbot wrote:
> From: Lucas Stach <dev@lynxeye.de>
> 
> On architectures for which access to GPU memory is non-coherent,
> caches need to be flushed and invalidated explicitly at the
> appropriate places. Introduce two small helpers to make things
> easy for TTM-based drivers.

Have you run this with DMA API debugging enabled?  I suspect you haven't,
and I recommend that you do.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
