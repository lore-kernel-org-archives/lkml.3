Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3HAGTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:19:32 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57669 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261Ab3HAGTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:19:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoFAHr8+VF5LPxHgWdsb2JhbABagzu5VIUugR8XDgEBFiYoPYFnAQEEATocFQ4FCwgDGAklDwUlAyETiAoFDblAFo9xB4QLA5delHQq
Date: Thu, 1 Aug 2013 16:19:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 00/11] Sync and VFS scalability improvements
Message-ID: <20130801061928.GR7118@dastard>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <CA+icZUX7aFAPBo_nhBLQ7-F465_Bujg5Cr5+xL+hfcwn6BMo=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUX7aFAPBo_nhBLQ7-F465_Bujg5Cr5+xL+hfcwn6BMo=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 08:48:40AM +0200, Sedat Dilek wrote:
> On Wed, Jul 31, 2013 at 6:15 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Hi folks,
> >
> > This series of patches is against the curent mmotm tree here:
> >
> > http://git.cmpxchg.org/cgit/linux-mmotm.git/
> >
> 
> "Current" is not precise enough... above tree has git-tags.

It's most certainly precise.  "current" always means the master
branch at the time the series was posted. I.e. same definition as
"top of tree"....

> As I am not a linux-fs expert I can try to test, preferably against a
> Linux-next release.
> Would you like to test against "vanilla" mmotm or is Linux-next
> suitable in your eyes?

mmotm is based on the linux-next tree at the time the tree was made.

> I have seen some typos... are you interested in such feedback?

feel free to point them out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
