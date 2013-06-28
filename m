Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3F1DAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:00:35 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61772 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F1DAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:00:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130627183631.GB22832@thunk.org>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard>
	<87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard>
	<87y59w5dye.fsf@devron.myhome.or.jp>
	<20130627063816.GD29790@dastard>
	<87ppv83tnn.fsf@devron.myhome.or.jp>
	<20130627094042.GZ29338@dastard>
	<87mwqb3m1e.fsf@devron.myhome.or.jp>
	<20130627183631.GB22832@thunk.org>
Date: Thu, 27 Jun 2013 20:00:32 -0700
Message-ID: <CAEsagEiT_=G5tnvLFyuYJ=UU-ixOzJEg5-12p7b0A=qqkshGAg@mail.gmail.com>
Subject: Re: [PATCH] Optimize wait_sb_inodes()
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Thu, Jun 27, 2013 at 11:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> If the goal is to optimize file system freeze operations, sure.  But
> that's also not a common operation, so if it burns a little extra CPU
> time, it wouldn't cause me to think that it was a high priority issue.
> Decreasing the wall clock time for a file system freeze operation
> would probably be a far more interesting goal.

Personally, any extra CPU burn bothers me. Maybe I am just
obsessive about that. Anyway, extra CPU usually does translate
into wall clock time, so optimizing sync would seem to be worth
the price of admission by that criterion alone. In general it's hard
to see why syncing fast and efficiently could ever be a bad thing.

I agree, not high priority. Not useless either. I see it more as a fit
and finish thing.

Regards,

Daniel
