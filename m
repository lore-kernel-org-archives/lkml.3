Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab3BYO7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:59:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:41581 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab3BYO7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:59:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,735,1355126400"; 
   d="scan'208";a="295561756"
Date: Mon, 25 Feb 2013 14:59:02 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915 not working on Dell e6410
Message-ID: <20130225145902.GA20532@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Felipe Balbi <balbi@ti.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20130225142411.GD15499@arwen.pp.htv.fi>
 <20130225143918.GA19874@cantiga.alporthouse.com>
 <20130225144312.GG15499@arwen.pp.htv.fi>
 <20130225144906.GB19874@cantiga.alporthouse.com>
 <20130225145622.GI15499@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225145622.GI15499@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:56:22PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Feb 25, 2013 at 02:49:07PM +0000, Chris Wilson wrote:
> > That looks like https://bugzilla.freedesktop.org/show_bug.cgi?id=60391
> > which is fixed by
> > 
> > commit da88a5f7f7d434e2cde1b3e19d952e6d84533662
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Wed Feb 13 09:31:53 2013 +0000
> > 
> >     drm/i915: Disable WC PTE updates to w/a buggy IOMMU on ILK
> > 
> > or by passing intel_iommu=off on the commandline.
> 
> and so it does, thanks. That's going to be merged on v3.9 right ? Hope
> there's a stable tag in it, thanks

Yes, it is in the queue of fixes for v3.9.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
