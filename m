Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaCXIs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:48:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:4571 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbaCXIsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,719,1389772800"; 
   d="scan'208";a="505290337"
From: Jani Nikula <jani.nikula@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
In-Reply-To: <20140324130135.d8788dffbc82ad210c53e258@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140324130135.d8788dffbc82ad210c53e258@canb.auug.org.au>
User-Agent: Notmuch/0.17+142~gb08654f2ff14 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 24 Mar 2014 10:49:15 +0200
Message-ID: <878us0vv5g.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
>
> Today's linux-next merge of the drm tree got conflicts in
> drivers/gpu/drm/i915/intel_ddi.c and
> drivers/gpu/drm/i915/intel_dp.c between commit 825938307f81 ("Revert
> "drm/i915: don't touch the VDD when disabling the panel"") from Linus'
> tree and commits 4be7378004a0 ("drm/i915: drop ironlake_ prefix from edp
> panel/backlight functions"), dce56b3c626f ("drm/i915: save some time when
> waiting the eDP timings") and b3064154dfd3 ("drm/i915: Don't just say it,
> actually force edp vdd") from the drm tree.
>
> This latter commit in the drm tree seems to be solving the same problem
> as the one in Linus' tree (but slightly differently), so I just
> effectively dropped the patch from Linus' tree and can carry the fix as
> necessary (no action is required).

Ack. We took the long route in our -next to come to the conclusion that
a revert is the way to go, and that was then queued for 3.14.

Thanks,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
