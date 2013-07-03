Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3GCHoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:44:38 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39338 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3GCHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:44:36 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130702223405.AF5BB5A4016@corp2gmr1-2.hot.corp.google.com>
References: <20130702223405.AF5BB5A4016@corp2gmr1-2.hot.corp.google.com>
Date: Wed, 3 Jul 2013 09:44:34 +0200
Message-ID: <CA+icZUWX761O5tAfdYfgR0_QA8zMiZOqBBjzbWVeEcZPL+M_pQ@mail.gmail.com>
Subject: Re: mmotm 2013-07-02-15-32 uploaded
From: Sedat Dilek <sedat.dilek@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 12:34 AM,  <akpm@linux-foundation.org> wrote:
> The mm-of-the-moment snapshot 2013-07-02-15-32 has been uploaded to
>
>    http://www.ozlabs.org/~akpm/mmotm/
>
> mmotm-readme.txt says
>
> README for mm-of-the-moment:
>
> http://www.ozlabs.org/~akpm/mmotm/
>
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
>
> You will need quilt to apply these patches to the latest Linus release (3.x
> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
>
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.
>
> This tree is partially included in linux-next.  To see which patches are
> included in linux-next, consult the `series' file.  Only the patches
> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
> linux-next.
>

Hi Andrew,

1st, I would like to see a diff to previous mmotm release.
Is that possible - with the announce.
For example, I like to diff series file of mmot*m* and mmot*s*.

AFAICS, you wanted to fold the fix into the real patch?

ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2.patch

3rd, is the "sysv-ipc-shm-optimizations" patchset from Davidlohr included here?
( I had no closer look. )

Thanks for maintaining -mm stuff!

Regards,
- Sedat -
