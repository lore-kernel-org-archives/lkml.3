Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaDHHN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:13:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:39947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234AbaDHHNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,816,1389772800"; 
   d="scan'208";a="516464226"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel J Blueman <daniel@quora.org>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] i915 DVI resolution regression (3.13.7+)
In-Reply-To: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
User-Agent: Notmuch/0.17+162~g34940eaa1d37 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 08 Apr 2014 10:14:04 +0300
Message-ID: <878urg9ttv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2014, Daniel J Blueman <daniel@quora.org> wrote:
> Ville et al,
>
> It looks like commit e3ea8fa6beaf55fee64bf816f3b8a80ad733b2c2 (or
> another commit in 3.13.7) broke modes which require DVI-D dual-link,
> eg 2560x1440 with my panel.
>
> I don't see these modelines in 3.13.7 or later (eg 3.14):
>
> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
> [     5.582] (II) intel(0): Modeline "1920x1200"x59.9  193.25  1920
> 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)
>
> My monitor is a Dell U2713HM; mobo uses an H87 chipset with i5-4670.

By allowing those modes we regressed setups which were not capable of
displaying them. So you've got an HDMI->DVI converter?

https://bugzilla.kernel.org/show_bug.cgi?id=72961


-- 
Jani Nikula, Intel Open Source Technology Center
