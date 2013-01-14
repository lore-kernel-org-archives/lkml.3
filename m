Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3ANKDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:03:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab3ANKDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:03:44 -0500
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
References: <20130108223611.GA19672@kroah.com>
	<20130109003824.GA21075@kroah.com>
	<CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com>
	<20130109042533.GA9164@kroah.com>
	<CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
	<50ED1C12.2090608@gmail.com> <50EDC8A1.30307@oracle.com>
	<50EDCF14.4080101@oracle.com> <8738y7skae.fsf@redhat.com>
	<CAKMK7uGpAHRgT3aj6bvU-13gaFe0u8gq19nDfo86JCJJy3R-tw@mail.gmail.com>
	<87obgsl08a.fsf@redhat.com>
	<CAKMK7uEd4xLCbiMiVvPGCWG2h5v32WEJVYUtwSsDxZmWu4rUZA@mail.gmail.com>
Date: Mon, 14 Jan 2013 10:49:08 +0100
In-Reply-To: <CAKMK7uEd4xLCbiMiVvPGCWG2h5v32WEJVYUtwSsDxZmWu4rUZA@mail.gmail.com>
	(Daniel Vetter's message of "Mon, 14 Jan 2013 10:06:49 +0100")
Message-ID: <878v7w14dn.fsf@redhat.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.2 (x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:

> On Mon, Jan 14, 2013 at 7:58 AM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
>> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
>>
>>> On Fri, Jan 11, 2013 at 6:26 PM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
>>>> bug still kicking even w/ (drm/i915: Revert shrinker changes from "Track
>>>> unbound pages")
>>>
>>> Could be a different bug, can you please attach the error_state somewhere?
>>
>> yep, i915_error_state is attached. btw, I'm going to bisect kernel, so
>> hopefully I will bring some commit.
>
> Different bug, on a quick lock this could be a dupe of
> https://bugzilla.kernel.org/show_bug.cgi?id=52311

ok

> Chris should know the details.

thanks, bisection leads me to commit d7d4eed ("drm/i915: Allow
DRM_ROOT_ONLY|DRM_MASTER to submit privileged batchbuffers). It's not
possible to simply revert/test commit and I have no idea how i915 works.

Chris any ideas?

-- 
Nikola
