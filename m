Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571Ab3CZOrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:47:33 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39700 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab3CZOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:47:32 -0400
Date: Tue, 26 Mar 2013 15:50:20 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 0/2] lib/scatterlist: sg_page_iter: support for memory
 w/o backing pages
Message-ID: <20130326145020.GT9021@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 03:14:17PM +0200, Imre Deak wrote:
> When adding sg_page_iter I haven't thought properly through the use case
> for sg lists w/o backing pages - which is specific to the i915 driver -
> so this patchset adds support for this.
> 
> It applies on the i915 tree [1], where the iterator is in use already.
> 
> [1] git://people.freedesktop.org/~danvet/drm-intel [nightly branch]

i915 patches are already included in linux-next, so should apply on top of
that, too. So can this go in through -mm for 3.10 or should I slurp it in
through drm-intel trees (once it passes review)? I'd like to ditch the
dummy page hack we're currently using (i.e. patch 2).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
