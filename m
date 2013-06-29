Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3F2XxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:53:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46992 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3F2XxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:53:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx54EDTS0R7E8JpPzqfx8M5c-0Q5Q_z0ybnM1mmBvA=ig@mail.gmail.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
 <CA+QCeVR=+2vpFdW_LcjZUdNd+udY4dZEWXxevONTnbs8Y6oECQ@mail.gmail.com>
 <CA+55aFy8XfmbhaEFUvy5ToLuSSxw5dhw5vXbJ28QpA0sBZgYoQ@mail.gmail.com>
 <CA+QCeVTOQks+s7YEK1Sd-aKdg2ce=Jxchb5ATqW0fiZVebFMBw@mail.gmail.com> <CA+55aFx54EDTS0R7E8JpPzqfx8M5c-0Q5Q_z0ybnM1mmBvA=ig@mail.gmail.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Sun, 30 Jun 2013 02:52:59 +0300
Message-ID: <CA+QCeVSA+hAzoxXMcEVaUAaqsMpDoe22AGpKg538mytQXQgyEg@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2013 01:13, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Jun 29, 2013 at 2:07 PM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>>> (and possibly the
>>> mkregtable binary) and trying again might fix it.
>>
>> Removing mkregtable  has indeed the compile issue for me. Thanks!
>
> Ok, so something failed at an earlier build. That error is probably
> long gone, though, since the subsequent build failure ends up being
> just a symptom rather than the underlying cause.

There was overheating issue, that caused forced power off in the
middle of the first compile.

>
>>> Which still leaves
>>> us with the question of how this happened, and a potentially fragile
>>> Makefile.
>
> Radeon/drm people - any ideas how that mkregtable failure happened?
>
>                    Linus
