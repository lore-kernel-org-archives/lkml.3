Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3C0AR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:17:56 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61583 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3C0ARz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:17:55 -0400
Date: Wed, 27 Mar 2013 01:20:43 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Damien Lespiau <damien.lespiau@intel.com>
Cc: Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH 0/2] lib/scatterlist: sg_page_iter: support
 for memory w/o backing pages
Message-ID: <20130327002043.GI9021@phenom.ffwll.local>
Mail-Followup-To: Damien Lespiau <damien.lespiau@intel.com>,
	Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
 <20130326225057.GA14347@strange.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326225057.GA14347@strange.amr.corp.intel.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 10:50:57PM +0000, Damien Lespiau wrote:
> On Tue, Mar 26, 2013 at 03:14:17PM +0200, Imre Deak wrote:
> > When adding sg_page_iter I haven't thought properly through the use case
> > for sg lists w/o backing pages - which is specific to the i915 driver -
> > so this patchset adds support for this.
> > 
> > It applies on the i915 tree [1], where the iterator is in use already.
> > 
> > [1] git://people.freedesktop.org/~danvet/drm-intel [nightly branch]
> > 
> > Imre Deak (2):
> >   lib/scatterlist: sg_page_iter: support sg lists w/o backing pages
> >   Revert "drm/i915: set dummy page for stolen objects"
> 
> Both patches are Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

Both patches merged, with Imre's missing sob line rectified on the 2nd
one.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
