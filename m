Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaIQIkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:40:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:4845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbaIQIkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:40:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="478076574"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] External monitor issues with 3.17-rc4 and i915	module
In-Reply-To: <20140916095419.GA8548@linux-g29b.site>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140909215430.GA3710@linux-g29b.site> <20140916095419.GA8548@linux-g29b.site>
User-Agent: Notmuch/0.18.1+85~gcca05ac (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 17 Sep 2014 11:39:57 +0300
Message-ID: <87vbomvdwi.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, "Carlos R. Mafra" <crmafra@gmail.com> wrote:
> Hi, the same happens with 3.17-rc5. The kernel is unfortunately
> unusable with my external monitor because after some plug, unplug
> and suspend to RAM cycles the behaviour is not good (sometimes
> it freezes, sometimes X needs a restart).
>
> Sorry to ask, but is there someone looking at this? I can provide
> more information if necessary.

Please file a new bug against DRM/Intel at [1] so we don't lose track of
it. Is this a regression? Which version worked? Can you do a bisect?

Please attach full dmesg with drm.debug=0xe module parameter set from
early boot to the problem.

BR,
Jani.


[1] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI


-- 
Jani Nikula, Intel Open Source Technology Center
