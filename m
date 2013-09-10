Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3IJXX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:23:27 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62902 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3IJXX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzRCNteHoSBRL9cVAHtZwA419G+fPBAaofYextsHpDLYw@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<CA+qSnqh1X6_xHD4GX1P=acEUg9+0=3dVSZHm-NYXvCvupFB8_g@mail.gmail.com>
	<CA+55aFzRCNteHoSBRL9cVAHtZwA419G+fPBAaofYextsHpDLYw@mail.gmail.com>
Date: Wed, 11 Sep 2013 09:23:24 +1000
Message-ID: <CAPM=9txf8oxpZX36AsjJ1hdwQaf3SUjrLskiw29LuBaw=nN-hw@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean V Kelley <sean.v.kelley@intel.com>, Dave Airlie <airlied@redhat.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 1:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> [ Dave - your linux.ie email generates bounces for me, trying redhat instead ]

Uggh no worries, I read my list mail from gmail mostly anyways, so if
its on a list I'll probably see it.

>> Can you give a little more detail about video not working?  Video
>> accel should work fine with the current versions of libva/intel-driver
>> available in Fedora 19 - assuming that's what you're using.
>
> It is indeed F19.
>
> Easy test: go to youtube, and watch things that are in 1080p HD. They
> play fine in a window (using about 70% CPU), but full-screened to
> 2560x1440 they play at about one or two frames per second.

It doesn't sound like you are using hw accelerated video at all and its just
sw renderered flash,

In which case it could be a CPU issue, is the cpu freq scaling working
correctly?

Dave.
