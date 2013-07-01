Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3GAIwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:52:51 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54749 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3GAIwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:52:49 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CA+icZUXyizuCR3YDfFXD5hCkgycFYGzMHaJxg=m9UackT7uzGQ@mail.gmail.com>
References: <CA+icZUXyizuCR3YDfFXD5hCkgycFYGzMHaJxg=m9UackT7uzGQ@mail.gmail.com>
Date: Mon, 1 Jul 2013 10:52:49 +0200
Message-ID: <CAKMK7uFzwiztE8H1rvSDWQmw08JGoKdnTs5BYqxdrHwb=pK50A@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 1 [ drm-intel-next: Several call-traces ]
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Sedat Dilek <sedat.dilek@gmail.com>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 10:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Mon, Jul 1, 2013 at 9:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20130628:
>>
>> The regulator tree gained a build failure so I used the version from
>> next-20130628.
>>
>> The trivial tree gained a conflict against the fbdev tree.
>>
>> The arm-soc tree gained a conflict against the net-next tree.
>>
>> The akpm tree lost a few patches that turned up elsewhere and I removed 2
>> that were causing run time problems.
>>
>
> [ CC drm and drm-intel folks ]
>
> [ Did not check any relevant MLs ]
>
> Please, see attached dmesg output.

Clock mismatch, one for Jesse to figure out. Note that this patch is
for 3.12, I simply haven't yet gotten around to properly split my
patch queue so a few spilled into -next. I'll do that now.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
