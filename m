Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaCCJbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:31:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:6615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbaCCJbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:31:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,576,1389772800"; 
   d="scan'208";a="491168978"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: prometheanfire@gentoo.org, daniel.vetter@ffwll.ch, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org,
        "kernel\@gentoo.org" <kernel@gentoo.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915 - Corruption on boot for 3.13.x
In-Reply-To: <5310BE23.3060204@gentoo.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <5310BE23.3060204@gentoo.org>
User-Agent: Notmuch/0.17+103~g5359c707b23e (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 03 Mar 2014 11:31:25 +0200
Message-ID: <87y50rpr0y.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Matthew Thode <prometheanfire@gentoo.org> wrote:
> Hardware is a T520 with a i5-2520M (intel only).
>
> Booting via uefi stub, kernel config is attached.
>
> This is broken on 3.13.x the video shows hardened kernel being booted,
> but I've tested kernel.org sources as well with the same effect.
>
> I can boot, login and shutdown, etc; just graphics is broken.
>
> https://www.youtube.com/watch?v=yxDyvyJTrXs
>
> Think that's it, let me know if there's more info I can get you.

Hi Matthew, thanks for the report.

Please file a bug on DRM/Intel component at [1]. Just because my gut
feeling says this will be better tracked there than by cluttering the
list...

On the bug, please indicate:

Did this use to work? Which kernel version?

Please disable i915.ko and see if there's still corruption in the
fb. It's hard to see from the video whether the corruption starts before
i915 gets loaded.

Please attach dmesg from early boot with drm.debug=0xe module parameter
set.


BR,
Jani.


[1] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI

-- 
Jani Nikula, Intel Open Source Technology Center
