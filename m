Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3F2WNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 18:13:32 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:60992 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3F2WNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 18:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QCeVTOQks+s7YEK1Sd-aKdg2ce=Jxchb5ATqW0fiZVebFMBw@mail.gmail.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<CA+QCeVR=+2vpFdW_LcjZUdNd+udY4dZEWXxevONTnbs8Y6oECQ@mail.gmail.com>
	<CA+55aFy8XfmbhaEFUvy5ToLuSSxw5dhw5vXbJ28QpA0sBZgYoQ@mail.gmail.com>
	<CA+QCeVTOQks+s7YEK1Sd-aKdg2ce=Jxchb5ATqW0fiZVebFMBw@mail.gmail.com>
Date: Sat, 29 Jun 2013 15:13:29 -0700
X-Google-Sender-Auth: DfFB2Pk-ttNu7n-a6XUEyPnSt2Y
Message-ID: <CA+55aFx54EDTS0R7E8JpPzqfx8M5c-0Q5Q_z0ybnM1mmBvA=ig@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 2:07 PM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>> (and possibly the
>> mkregtable binary) and trying again might fix it.
>
> Removing mkregtable  has indeed the compile issue for me. Thanks!

Ok, so something failed at an earlier build. That error is probably
long gone, though, since the subsequent build failure ends up being
just a symptom rather than the underlying cause.

>> Which still leaves
>> us with the question of how this happened, and a potentially fragile
>> Makefile.

Radeon/drm people - any ideas how that mkregtable failure happened?

                   Linus
