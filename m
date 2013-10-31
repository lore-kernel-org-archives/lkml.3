Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3JaQl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:41:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3JaQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:41:24 -0400
Message-ID: <5272882D.2070807@canonical.com>
Date: Thu, 31 Oct 2013 12:41:17 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, przanoni@gmail.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert
 "Revert "drm/i915: revert eDP bpp clamping code changes""
References: <cover.1381939165.git.joseph.salisbury@canonical.com> <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com> <20131016210213.GR4830@phenom.ffwll.local> <526A8FE3.8040801@canonical.com> <87txfxpjv1.fsf@intel.com>
In-Reply-To: <87txfxpjv1.fsf@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 10:58 AM, Jani Nikula wrote:
> On Fri, 25 Oct 2013, Joseph Salisbury <joseph.salisbury@canonical.com> wrote:
>> On 10/16/2013 05:02 PM, Daniel Vetter wrote:
>>> It's by far not that simple. Jani is working on both the underlying bug
>>> and a better w/a. See
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=59841
>>>
>>> for the full story in its entire glory.
>>>
>>> Cheers, Daniel
>> Thanks for the feedback, Daniel.  Is there an estimate on what mainline
>> release might contain Jani's work?
> commit c6cd2ee2d59111a07cd9199564c9bdcb2d11e5cf
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Mon Oct 21 10:52:07 2013 +0300
>
>     drm/i915/dp: workaround BIOS eDP bpp clamping issue
>
> and a couple of dependencies are now in Linus' tree, i.e. should be
> released in 3.12. The commits are also CC: stable.
>
> BR,
> Jani.
>
>
Great news!  Thanks, Jani.
