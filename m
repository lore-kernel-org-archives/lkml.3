Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3JaRE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:04:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:61548 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3JaRE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:04:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401667249"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>, przanoni@gmail.com,
        Dave Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert "Revert "drm/i915: revert eDP bpp clamping code changes""
In-Reply-To: <CA+5PVA7j+90_iwZD+Gx9cAuqwEGH+cKB98OQj2+w4fhC_JT0pw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1381939165.git.joseph.salisbury@canonical.com> <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com> <20131016210213.GR4830@phenom.ffwll.local> <526A8FE3.8040801@canonical.com> <87txfxpjv1.fsf@intel.com> <CA+5PVA7j+90_iwZD+Gx9cAuqwEGH+cKB98OQj2+w4fhC_JT0pw@mail.gmail.com>
User-Agent: Notmuch/0.16+114~g6de60df (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 31 Oct 2013 19:01:16 +0200
Message-ID: <87txfxml2b.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Thu, Oct 31, 2013 at 10:58 AM, Jani Nikula
> <jani.nikula@linux.intel.com> wrote:
>> On Fri, 25 Oct 2013, Joseph Salisbury <joseph.salisbury@canonical.com> wrote:
>>> On 10/16/2013 05:02 PM, Daniel Vetter wrote:
>>>> It's by far not that simple. Jani is working on both the underlying bug
>>>> and a better w/a. See
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=59841
>>>>
>>>> for the full story in its entire glory.
>>>>
>>>> Cheers, Daniel
>>>
>>> Thanks for the feedback, Daniel.  Is there an estimate on what mainline
>>> release might contain Jani's work?
>>
>> commit c6cd2ee2d59111a07cd9199564c9bdcb2d11e5cf
>> Author: Jani Nikula <jani.nikula@intel.com>
>> Date:   Mon Oct 21 10:52:07 2013 +0300
>>
>>     drm/i915/dp: workaround BIOS eDP bpp clamping issue
>>
>> and a couple of dependencies are now in Linus' tree, i.e. should be
>> released in 3.12. The commits are also CC: stable.
>
> Are the dependency commits you mentioned these?

Yes; sorry for not mentioning them explicitly.

BR,
Jani.


> commit 7195a50b5c7e00cc3312934fd022c3006b533d12
> Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Date:   Tue Sep 24 14:24:05 2013 +0300
>
>     drm/i915: Add HSW CRT output readout support
>
> commit 4f56d12ebb28fceac4c6e60c8993fbfc122e1399
> Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Date:   Mon Oct 21 10:52:06 2013 +0300
>
>     drm/i915: Add support for pipe_bpp readout
>
> josh

-- 
Jani Nikula, Intel Open Source Technology Center
