Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3CZWvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:51:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:25961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab3CZWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:51:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="307830269"
Date: Tue, 26 Mar 2013 22:50:57 +0000
From: Damien Lespiau <damien.lespiau@intel.com>
To: Imre Deak <imre.deak@intel.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH 0/2] lib/scatterlist: sg_page_iter: support
 for memory w/o backing pages
Message-ID: <20130326225057.GA14347@strange.amr.corp.intel.com>
References: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
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
> 
> Imre Deak (2):
>   lib/scatterlist: sg_page_iter: support sg lists w/o backing pages
>   Revert "drm/i915: set dummy page for stolen objects"

Both patches are Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

-- 
Damien
