Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaDWVdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:33:49 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:63059 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaDWVds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:33:48 -0400
Message-ID: <5358325D.6010409@gmail.com>
Date: Wed, 23 Apr 2014 17:36:29 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ed Tomlinson <edt@aei.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        =?UTF-8?B?Q2hyaXN0aWE=?= =?UTF-8?B?biBLw7ZuaWc=?= 
	<christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>	<2619529.mEMJol0YfM@grover>	<1549585.kmUPduLgev@grover>	<10435496.M4aSBzoVye@grover>	<CA+55aFwbOQCcd1qsW0rA+bQxN2Vgm9x832ZKmB7fndFX7DBE3w@mail.gmail.com> <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com>
In-Reply-To: <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Wed, Apr 23, 2014 at 1:59 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Dave, mind sending me a pull request for drm fixes?
>>
>> There's now at least these two:
>>
>>   - "drm/radeon/aux: fix hpd assignment for aux bus"
>>   - "drm/radeon: use fixed PPL ref divider if needed"
>>
>> that look like fairly fatal regressions when they affect somebody.
>>
>> The fact that we already had *two* independent bugs be reported within
>> days of that last out-of-merge-window pull request makes me very
>> unhappy with the state of drm pulls.
>>
>> So please make sure that future fixes really are *fixes*. For
>> regressions only. No more games like this.
> The pll fallout is fixes for the initial feature that was in the merge window,
> Tuning plls for monitors is always a pain in the ass, the previous algorithm
> took a couple of kernels a few years back to get where it was, unfortunately
> HDMI came along and showed up a bunch of its shortcomings. I'm happy
> Alex and Christian are on top of things in terms of tracking regressions
> and making sure they get fixed,
>
> the AUX fix yes I'm a bit pissed off about myself, but I missed a pull
> from a few
> weeks ago, felt guilty, and maybe should have chosen the other path and let it
> wait a merge,
>
> Christian just sent me a -fixes pull with all of these in it and I'll
> send it on to you
> in a few mins.
>
> Dave.
>
That patch also fixes a shimmering (water floating) issue on Radeon 
RV635 (Thinkpad T500)
1002:9591

