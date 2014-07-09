Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaGIIzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:55:21 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36805 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaGIIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:55:16 -0400
Date: Wed, 9 Jul 2014 01:53:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Herrmann <dh.herrmann@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
In-Reply-To: <CANq1E4QZ95RmJ7i=6TzEP4e+WREzKtXmmjjDrvz4BgAhVHoeuQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1407090136580.7841@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com> <CANq1E4QZ95RmJ7i=6TzEP4e+WREzKtXmmjjDrvz4BgAhVHoeuQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, David Herrmann wrote:
> 
> Hugh, any comments on patch 5, 6 and 7? Those are the last outstanding
> issues with memfd+sealing. Patch 7 (isolating pages) is still my
> favorite and has been running just fine on my machine for the last
> months. I think it'd be nice if we could give it a try in -next. We
> can always fall back to Patch 5 or Patch 5+6. Those will detect any
> racing AIO and just fail or wait for the IO to finish for a short
> period.

It's distressing for both of us how slow I am to review these, sorry.
We have just too many bugs in mm (and yes, some of them mine) for me
to set aside time to get deep enough into new features.

I've been trying for days and weeks to get there, made some progress
today, and hope to continue tomorrow.  I'll send my comments on 1/7
(thumb up) and 7/7 (thumb down) in a moment: 2-6 not tonight.

> 
> Are there any other blockers for this?

Trivia only, I haven't noticed any blocker; though I'm still not quite
convinced by memfd_create() - but happy enough with it if others are.

Hugh
