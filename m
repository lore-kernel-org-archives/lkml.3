Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaAWBVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 20:21:31 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:54311 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAWBV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 20:21:29 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:cda5:d5b8:bf47:af28]
In-Reply-To: <CAKMK7uF+p96YtDo3NG4nBV5S5gYXk55p5KUOxsb+PMY+MH_Zyw@mail.gmail.com>
References: <20140122140402.20163da276690810a1040909@canb.auug.org.au>
	<CAKMK7uF+p96YtDo3NG4nBV5S5gYXk55p5KUOxsb+PMY+MH_Zyw@mail.gmail.com>
Date: Wed, 22 Jan 2014 17:21:28 -0800
Message-ID: <CAOesGMgtavy=gSJQeqqxQFXgSwKGekU2=vwnN2o2TeWhG0bktg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm-intel tree with the drm tree
From: Olof Johansson <olof@lixom.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 2:06 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Hi Stephen,
>
> On Wed, Jan 22, 2014 at 4:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Today's linux-next merge of the drm-intel tree got a conflict in
>> drivers/gpu/drm/i915/i915_irq.c between commit abca9e454498 ("drm: Pass
>> 'flags' from the caller to .get_scanout_position()") from the drm tree
>> and commit d59a63ad8234 ("drm/i915: Add intel_get_crtc_scanline()") from
>> the drm-intel tree.
>>
>> I fixed it up (I think - see below) and can carry the fix as necessary
>> (no action is required).
>
> Oops, this patch escaped - it's only for 3.15. I've shuffled my
> branches around now for the merge window so this should not pop up in
> your -next tree again until 3.15 starts.

I just bisected boot failures on x86 chromebooks with -next to this
merge commit. I'll take a look tomorrow morning and make sure they're
gone.


-Olof
