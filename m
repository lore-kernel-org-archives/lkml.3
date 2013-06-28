Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3F1JVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:21:30 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44330 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3F1JV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:21:28 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVDX+rGMHaO3Pi+jRmHVs_QtdBOYcO++ugHPy4CmFurZA@mail.gmail.com>
References: <CA+icZUUsDoJHDk0Ug7FRc652CJvmcNdvhT1x44+8LOA2OSU3Hg@mail.gmail.com>
	<CAPM=9tySnq0SDJEy0qvhhqjTnsSNTMuYzaMgOoi44SBRhuTF2Q@mail.gmail.com>
	<CA+icZUVDX+rGMHaO3Pi+jRmHVs_QtdBOYcO++ugHPy4CmFurZA@mail.gmail.com>
Date: Fri, 28 Jun 2013 11:21:27 +0200
Message-ID: <CA+icZUVJmUYFVOLTzkSqzw7+CW0TwK2S+vq=To8Cu2EpcNSxcQ@mail.gmail.com>
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

On Fri, Jun 28, 2013 at 10:31 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jun 28, 2013 at 10:29 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>
>>> [ CC wq and drm(-intel) folks ]
>>>
>>
>> Already know the commit which caused it, mentioned on dri-devel,
>> waiting for danvet to wake up and look, before I revert it later.
>>
>
> Thanks, I like fast responses.
>
> For followers... See "workqueue warnings in helper code"
>
> - Sedat -
>
> http://lists.freedesktop.org/archives/dri-devel/2013-June/040707.html
>

Just FYI:

Daniel decided to revert [2] (see [1]).

commit 160954b7bca43da7cd3cfbce310e6df919a8216e
"drm: kms_helper: don't lose hotplug event"

- Sedat -

[1] http://lists.freedesktop.org/archives/dri-devel/2013-June/040721.html
[2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=160954b7bca43da7cd3cfbce310e6df919a8216e

>> Dave.
