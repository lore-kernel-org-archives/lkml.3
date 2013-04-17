Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966825Ab3DQU7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:59:38 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46599 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966800Ab3DQU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:59:36 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAMbhsRTwRSW_c5xSMC4Xk3aQFDoqXpcfspxoqOPiUmfPwNa1EQ@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
	<CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
	<CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
	<CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
	<CAJfpegt53MRwiMgZTW2DogMWAR54vrPMG=D5Yqs_vpfccPi_5Q@mail.gmail.com>
	<CAMbhsRR7iWabAgMqJ8g6FJK+SMAf_s0Rrz+wHiODzoB6joAzCw@mail.gmail.com>
	<20130417095728.GA20829@tucsk.piliscsaba.szeredi.hu>
	<CAMbhsRTwRSW_c5xSMC4Xk3aQFDoqXpcfspxoqOPiUmfPwNa1EQ@mail.gmail.com>
Date: Wed, 17 Apr 2013 22:59:35 +0200
Message-ID: <CAJfpegusPiLw4Vy8LML-o0G37sTmUpP9vmEwuXpFBEOSjm_4+Q@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Miklos Szeredi <miklos@szeredi.hu>
To: Colin Cross <ccross@android.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 9:45 PM, Colin Cross <ccross@android.com> wrote:
> This fixes my build issue, and doesn't introduce a new make
> headers_check warning so you can add my Tested-by: Colin Cross
> <ccross@android.com>

Thanks for testing.

Linus,  can you please pull this single fix from:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos
----

Miklos Szeredi (1):
      fuse: fix type definitions in uapi header

---
 include/uapi/linux/fuse.h |  436 ++++++++++++++++++++++-----------------------
 1 file changed, 216 insertions(+), 220 deletions(-)
