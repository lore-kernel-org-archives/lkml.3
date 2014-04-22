Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaDVLyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:54:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:18049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbaDVLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:54:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="517197683"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [Bug 3.15-rc2] intel framebuffer broken
In-Reply-To: <53554B59.8080107@t-online.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <53554B59.8080107@t-online.de>
User-Agent: Notmuch/0.18~rc0+1~g40dc79d6ac82 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 22 Apr 2014 14:54:03 +0300
Message-ID: <87tx9lh95w.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> Booting kernel 3.15-rc2 on an AOpen i915GMm-hfs, I see the framebuffer broken.
> Only about the upper left quarter of the monitor is used for displaying the boot messages,
> these (and the cursor) are replicated at the right of that area.

Is this before or after i915.ko is loaded?

> Approximately the lower half of the monitor stays black. The output of the xserver
> is not affected.

Most likely the fastest way to root cause is to bisect, please do. To
keep track of all the bugs we have, please file a bug on DRM/Intel at
[1] and while at it attach dmesg with drm.debug=0xe from the boot.

BR,
Jani.


[1] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI


-- 
Jani Nikula, Intel Open Source Technology Center
