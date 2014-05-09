Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaEIMWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:22:46 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58378 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaEIMWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:22:44 -0400
MIME-Version: 1.0
X-Originating-IP: [2a02:f28:a:222:c685:8ff:fe10:f3d8]
In-Reply-To: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
References: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
Date: Fri, 9 May 2014 14:22:44 +0200
Message-ID: <CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
Subject: Re: [3.14.0-rc4] regression: drm FIFO underruns
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding mailing lists.

Jörg, can you please boot with drm.debug=0xe, reproduce the issue and
then attach the complete dmesg? Please make sure that the dmesg
contains the boot-up stuff too.

Thanks, Daniel

On Mon, May 5, 2014 at 9:51 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> I still have FIFO underruns in drm:
> [drm:ivb_err_int_handler] *ERROR* Pipe B FIFO underrun
> [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
> [drm:cpt_serr_int_handler] *ERROR* PCH transcoder B FIFO underrun
>
> which I already reported here:
> https://lkml.org/lkml/2014/4/9/127
>
> and which is still unanswered!
>
> I tried to bisect the thing, but I ran into compile errors. So I
> can only say it came in with
> e9f37d3 "Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux"
>
> Jörg



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
