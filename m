Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3F1Jaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:30:35 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:51612 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3F1Jad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:30:33 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVJmUYFVOLTzkSqzw7+CW0TwK2S+vq=To8Cu2EpcNSxcQ@mail.gmail.com>
References: <CA+icZUUsDoJHDk0Ug7FRc652CJvmcNdvhT1x44+8LOA2OSU3Hg@mail.gmail.com>
	<CAPM=9tySnq0SDJEy0qvhhqjTnsSNTMuYzaMgOoi44SBRhuTF2Q@mail.gmail.com>
	<CA+icZUVDX+rGMHaO3Pi+jRmHVs_QtdBOYcO++ugHPy4CmFurZA@mail.gmail.com>
	<CA+icZUVJmUYFVOLTzkSqzw7+CW0TwK2S+vq=To8Cu2EpcNSxcQ@mail.gmail.com>
Date: Fri, 28 Jun 2013 11:30:32 +0200
Message-ID: <CA+icZUXLMGeHom=8Gye8nBZoRxm7KTxy0ofXQsw4nfCayx5b_w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 28 [ call-trace: workqueue | drm
 releated? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jun 28, 2013 at 10:31 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Fri, Jun 28, 2013 at 10:29 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>>
>>>> [ CC wq and drm(-intel) folks ]
>>>>
>>>
>>> Already know the commit which caused it, mentioned on dri-devel,
>>> waiting for danvet to wake up and look, before I revert it later.
>>>
>>
>> Thanks, I like fast responses.
>>
>> For followers... See "workqueue warnings in helper code"
>>
>> - Sedat -
>>
>> http://lists.freedesktop.org/archives/dri-devel/2013-June/040707.html
>>
>
> Just FYI:
>
> Daniel decided to revert [2] (see [1]).
>
> commit 160954b7bca43da7cd3cfbce310e6df919a8216e
> "drm: kms_helper: don't lose hotplug event"
>

I have tested that with my -2 build and the call-traces are gone.

Feel free to add my Reported-by/Tested-by.

- Sedat -

> - Sedat -
>
> [1] http://lists.freedesktop.org/archives/dri-devel/2013-June/040721.html
> [2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=160954b7bca43da7cd3cfbce310e6df919a8216e
>
>>> Dave.
