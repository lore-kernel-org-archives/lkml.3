Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaDYWJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:09:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62002 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaDYWJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:09:49 -0400
Message-ID: <535ADDD3.2090006@gmail.com>
Date: Fri, 25 Apr 2014 18:12:35 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ed Tomlinson <edt@aei.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>	<2619529.mEMJol0YfM@grover>	<1549585.kmUPduLgev@grover>	<10435496.M4aSBzoVye@grover>	<CA+55aFwbOQCcd1qsW0rA+bQxN2Vgm9x832ZKmB7fndFX7DBE3w@mail.gmail.com> <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com> <5358325D.6010409@gmail.com> <5358C8B5.7020609@amd.com>
In-Reply-To: <5358C8B5.7020609@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian König wrote:
> Am 23.04.2014 23:36, schrieb Woody Suwalski:
>> Dave Airlie wrote:
>>> On Wed, Apr 23, 2014 at 1:59 AM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> Dave, mind sending me a pull request for drm fixes?
>>>>
>>>> There's now at least these two:
>>>>
>>>>   - "drm/radeon/aux: fix hpd assignment for aux bus"
>>>>   - "drm/radeon: use fixed PPL ref divider if needed"
>>>>
>>>> that look like fairly fatal regressions when they affect somebody.
>>>>
>>>> The fact that we already had *two* independent bugs be reported within
>>>> days of that last out-of-merge-window pull request makes me very
>>>> unhappy with the state of drm pulls.
>>>>
>>>> So please make sure that future fixes really are *fixes*. For
>>>> regressions only. No more games like this.
>>> The pll fallout is fixes for the initial feature that was in the 
>>> merge window,
>>> Tuning plls for monitors is always a pain in the ass, the previous 
>>> algorithm
>>> took a couple of kernels a few years back to get where it was, 
>>> unfortunately
>>> HDMI came along and showed up a bunch of its shortcomings. I'm happy
>>> Alex and Christian are on top of things in terms of tracking 
>>> regressions
>>> and making sure they get fixed,
>>>
>>> the AUX fix yes I'm a bit pissed off about myself, but I missed a pull
>>> from a few
>>> weeks ago, felt guilty, and maybe should have chosen the other path 
>>> and let it
>>> wait a merge,
>>>
>>> Christian just sent me a -fixes pull with all of these in it and I'll
>>> send it on to you
>>> in a few mins.
>>>
>>> Dave.
>>>
>> That patch also fixes a shimmering (water floating) issue on Radeon 
>> RV635 (Thinkpad T500)
>> 1002:9591
>
> Was this a long outstanding bug or a regression introduced with one of 
> the recent patches?
>
> Thanks for the info,
> Christian.
Regression from 3.15-rc1 (still OK in -rc1, shimmering in -rc2)
Woody
