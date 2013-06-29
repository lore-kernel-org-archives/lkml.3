Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3F2Xel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:34:41 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:58300 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3F2Xej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:34:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx54EDTS0R7E8JpPzqfx8M5c-0Q5Q_z0ybnM1mmBvA=ig@mail.gmail.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<CA+QCeVR=+2vpFdW_LcjZUdNd+udY4dZEWXxevONTnbs8Y6oECQ@mail.gmail.com>
	<CA+55aFy8XfmbhaEFUvy5ToLuSSxw5dhw5vXbJ28QpA0sBZgYoQ@mail.gmail.com>
	<CA+QCeVTOQks+s7YEK1Sd-aKdg2ce=Jxchb5ATqW0fiZVebFMBw@mail.gmail.com>
	<CA+55aFx54EDTS0R7E8JpPzqfx8M5c-0Q5Q_z0ybnM1mmBvA=ig@mail.gmail.com>
Date: Sun, 30 Jun 2013 09:34:37 +1000
Message-ID: <CAPM=9twR68GC=9qz-vFVoq4BKbCkzYJR5ANCGJK57uLR7oUSrw@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Meirovich <rathamahata@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 8:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jun 29, 2013 at 2:07 PM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>>> (and possibly the
>>> mkregtable binary) and trying again might fix it.
>>
>> Removing mkregtable  has indeed the compile issue for me. Thanks!
>
> Ok, so something failed at an earlier build. That error is probably
> long gone, though, since the subsequent build failure ends up being
> just a symptom rather than the underlying cause.
>
>>> Which still leaves
>>> us with the question of how this happened, and a potentially fragile
>>> Makefile.
>
> Radeon/drm people - any ideas how that mkregtable failure happened?
>

I'd care if we can definitely rule out previous power fails or forced reboots.
Otherwise just seems like noise, if gcc can produce 0 sized binaries
then I'm sure we'd have other issues.

Dave.
