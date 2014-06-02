Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaFBPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:21:40 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55387 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaFBPVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:21:39 -0400
Date: Mon, 2 Jun 2014 17:21:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Damien Lespiau <damien.lespiau@intel.com>
Cc: Robin Schroer <sulamiification@gmail.com>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drivers/gpu/drm/i915/dma: style fixes
Message-ID: <20140602152132.GT19050@phenom.ffwll.local>
Mail-Followup-To: Damien Lespiau <damien.lespiau@intel.com>,
	Robin Schroer <sulamiification@gmail.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <20140602145939.GA16534@shodan.fritz.box>
 <20140602151008.GF20418@strange.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602151008.GF20418@strange.amr.corp.intel.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 04:10:08PM +0100, Damien Lespiau wrote:
> On Mon, Jun 02, 2014 at 04:59:39PM +0200, Robin Schroer wrote:
> > Fixed several double space pointer notations, and added one newline
> > 
> > Signed-off-by: Robin Schroer <sulamiification@gmail.com>
> 
> Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

Queued for -next, thanks for the patch. Aside: If you want to do some
janitorial tasks in drm/i915, here's a list:

http://www.x.org/wiki/DRMJanitors/

Imo pure coding-style fixes are fairly pointless, at least if their
free-standing.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
