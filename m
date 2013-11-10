Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3KJQIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:08:21 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55788 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KJQIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:08:20 -0500
Date: Sun, 10 Nov 2013 08:10:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel <opw-kernel@googlegroups.com>, Minchan Kim <minchan@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [OPW kernel] Re: [PATCH v10] Staging: zram: Fix memory leak by
 refcount mismatch
Message-ID: <20131110161049.GA17019@kroah.com>
References: <20131019110539.GA25167@gmail.com>
 <1383314769-3667-1-git-send-email-rashika.kheria@gmail.com>
 <20131110154522.GA28926@kroah.com>
 <CAMpEsFGXz5vo4u42MH29eZ8oBC3JB-p6+rvuLWhBZXmMWdL7TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMpEsFGXz5vo4u42MH29eZ8oBC3JB-p6+rvuLWhBZXmMWdL7TQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 09:26:15PM +0530, Rashika Kheria wrote:
> On Sun, Nov 10, 2013 at 9:15 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Fri, Nov 01, 2013 at 07:36:09PM +0530, Rashika Kheria wrote:
> >> As suggested by Minchan Kim and Jerome Marchand "The code in reset_store
> >> get the block device (bdget_disk()) but it does not put it (bdput()) when
> >> it's done using it. The usage count is therefore incremented but never
> >> decremented."
> >>
> >> This patch also puts bdput() for all error cases.
> >>
> >> Acked-by: Minchan Kim <minchan@kernel.org>
> >> Acked-by: Jerome Marchand <jmarchan@redhat.com>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> >> ---
> >>
> >> This revision fixes the following issue of the previous revision-
> >> Incorrect Subject Line
> >
> > I'm a bit confused now, I see three different zram patches from you,
> > with different subjects, are they all now just in one patch, this one?
> >
> > Can you just send me the outstanding zram patches that you have gotten
> > acks from that you want applied, as I'm lost here.
> >
> > thanks,
> >
> > greg "easily confused" k-h
> >
> 
> Hi Greg,
> 
> You have already applied the rest two patches for this driver. This is
> the only patch which is left.
> 
> But I think you might have problem applying this because there have
> been changes in previous patches later i.e you applied v8 of this
> series, while, maintainers later suggested to change more and hence v9
> was also introduced.
> 
> Therefore, v9's patch 1 and v10 patch is correct to be applied in the tree.

Hm, can you please resend them, as I no longer have them in my queue.

thanks,

greg k-h
