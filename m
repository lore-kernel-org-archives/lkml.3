Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBYICF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:02:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:1185 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaBYICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:02:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,538,1389772800"; 
   d="scan'208";a="487603813"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>, Josh Boyer <jwboyer@fedoraproject.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: 3.13 i915 brightness settings broken when going from docked -> undocked
In-Reply-To: <1392882819.5070.15.camel@x220>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com> <1392882819.5070.15.camel@x220>
User-Agent: Notmuch/0.17+61~gab0de040c7c1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 25 Feb 2014 10:05:57 +0200
Message-ID: <878usz8vmi.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Paul Bolle <pebolle@tiscali.nl> wrote:
> On an (rather old) ThinkPad X41, which also uses i915, brightness
> adjustments stopped working altogether in v3.14-rc1 (I haven't used its
> docking station in the v3.14 release cycle). In v3.13.y things behave as
> expected. So perhaps there's actually a more general problem here.

I presume different problems. Does the ThinkPad X41 have gen3 graphics?
(See e.g. /sys/kernel/debug/dri/0/i915_capabilities) If yes, it might be
https://bugs.freedesktop.org/show_bug.cgi?id=75001

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
