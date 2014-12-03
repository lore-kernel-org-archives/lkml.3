Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaLCIYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:24:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:26804 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaLCIYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:24:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="641739796"
From: Jani Nikula <jani.nikula@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the drm tree with the drm-intel-fixes tree
In-Reply-To: <20141203132708.7423b7f8@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20141203132708.7423b7f8@canb.auug.org.au>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Dec 2014 10:24:12 +0200
Message-ID: <87d281nntf.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
>
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/i915/intel_display.c between commit b68362278af9
> ("drm/i915: More cautious with pch fifo underruns") from the
> drm-intel-fixes tree and commit a72e4c9f9a11 ("drm/i915: Use dev_priv
> in public intel_fifo_underrun.c functions") from the drm tree.
>
> I fixed it up (I used the drm tree version) and can carry the fix as
> necessary (no action is required).

b68362278af9 removes two lines of code; these should be removed in the
resolved version too.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
