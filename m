Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab3GCXFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:05:01 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41343 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3GCXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:04:59 -0400
Message-ID: <1372892697.8728.22.camel@buesod1.americas.hpqcorp.net>
Subject: Re: mmotm 2013-07-02-15-32 uploaded
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: sedat.dilek@gmail.com
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Date: Wed, 03 Jul 2013 16:04:57 -0700
In-Reply-To: <CA+icZUWX761O5tAfdYfgR0_QA8zMiZOqBBjzbWVeEcZPL+M_pQ@mail.gmail.com>
References: <20130702223405.AF5BB5A4016@corp2gmr1-2.hot.corp.google.com>
	 <CA+icZUWX761O5tAfdYfgR0_QA8zMiZOqBBjzbWVeEcZPL+M_pQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 09:44 +0200, Sedat Dilek wrote:
> On Wed, Jul 3, 2013 at 12:34 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2013-07-02-15-32 has been uploaded to
> >
> >    http://www.ozlabs.org/~akpm/mmotm/
> >
> > mmotm-readme.txt says
> >
> > README for mm-of-the-moment:
> >
> > http://www.ozlabs.org/~akpm/mmotm/
> >
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> >
> > You will need quilt to apply these patches to the latest Linus release (3.x
> > or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > http://ozlabs.org/~akpm/mmotm/series
> >
> > The file broken-out.tar.gz contains two datestamp files: .DATE and
> > .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> > followed by the base kernel version against which this patch series is to
> > be applied.
> >
> > This tree is partially included in linux-next.  To see which patches are
> > included in linux-next, consult the `series' file.  Only the patches
> > within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
> > linux-next.
> >
> 
> Hi Andrew,
> 
> 1st, I would like to see a diff to previous mmotm release.
> Is that possible - with the announce.
> For example, I like to diff series file of mmot*m* and mmot*s*.
> 
> AFAICS, you wanted to fold the fix into the real patch?
> 
> ipcmsg-shorten-critical-region-in-msgctl_down.patch
> ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2.patch

IIRC, it will be folded in once it reaches Linus.

> 
> 3rd, is the "sysv-ipc-shm-optimizations" patchset from Davidlohr included here?
> ( I had no closer look. )

Those are being considered for 3.12 now, I'll resend the patchset once
3.11-rc1 is out.

Thanks,
Davidlohr

