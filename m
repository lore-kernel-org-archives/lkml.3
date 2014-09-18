Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaIRLsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:48:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:40215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaIRLst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="388000967"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] External monitor issues with 3.17-rc4 and i915	module
In-Reply-To: <20140918110329.GA4687@linux-g29b.site>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140909215430.GA3710@linux-g29b.site> <20140916095419.GA8548@linux-g29b.site> <87vbomvdwi.fsf@intel.com> <20140918110329.GA4687@linux-g29b.site>
User-Agent: Notmuch/0.18.1+85~gcca05ac (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 18 Sep 2014 14:48:34 +0300
Message-ID: <87zjdx6tf1.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, "Carlos R. Mafra" <crmafra@gmail.com> wrote:
> On Wed, 17 Sep 2014 at 11:39:57 +0300, Jani Nikula wrote:
>> On Tue, 16 Sep 2014, "Carlos R. Mafra" <crmafra@gmail.com> wrote:
>> > Hi, the same happens with 3.17-rc5. The kernel is unfortunately
>> > unusable with my external monitor because after some plug, unplug
>> > and suspend to RAM cycles the behaviour is not good (sometimes
>> > it freezes, sometimes X needs a restart).
>> >
>> > Sorry to ask, but is there someone looking at this? I can provide
>> > more information if necessary.
>> 
>> Please file a new bug against DRM/Intel at [1] so we don't lose track of
>> it.
>
> https://bugs.freedesktop.org/show_bug.cgi?id=84038

Thanks, we'll track it there from now on.

-- 
Jani Nikula, Intel Open Source Technology Center
