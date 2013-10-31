Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3JaPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:02:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab3JaPCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401594054"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        przanoni@gmail.com, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert "Revert "drm/i915: revert eDP bpp clamping code changes""
In-Reply-To: <526A8FE3.8040801@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1381939165.git.joseph.salisbury@canonical.com> <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com> <20131016210213.GR4830@phenom.ffwll.local> <526A8FE3.8040801@canonical.com>
User-Agent: Notmuch/0.16+114~g6de60df (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 31 Oct 2013 16:58:58 +0200
Message-ID: <87txfxpjv1.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013, Joseph Salisbury <joseph.salisbury@canonical.com> wrote:
> On 10/16/2013 05:02 PM, Daniel Vetter wrote:
>> It's by far not that simple. Jani is working on both the underlying bug
>> and a better w/a. See
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=59841
>>
>> for the full story in its entire glory.
>>
>> Cheers, Daniel
>
> Thanks for the feedback, Daniel.  Is there an estimate on what mainline
> release might contain Jani's work?

commit c6cd2ee2d59111a07cd9199564c9bdcb2d11e5cf
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Mon Oct 21 10:52:07 2013 +0300

    drm/i915/dp: workaround BIOS eDP bpp clamping issue

and a couple of dependencies are now in Linus' tree, i.e. should be
released in 3.12. The commits are also CC: stable.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
