Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaATElq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:41:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64935 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaATElo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:41:44 -0500
X-AuditID: 9c930197-b7b7cae000000e34-6a-52dca9054ef9
Date: Mon, 20 Jan 2014 13:42:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/8] zram stats rework and code cleanup
Message-ID: <20140120044248.GA8155@bbox>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20140117070933.GL26602@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117070933.GL26602@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:09:34PM +0900, Minchan Kim wrote:
> On Thu, Jan 16, 2014 at 04:12:08PM +0300, Sergey Senozhatsky wrote:
> > This patchset includes zram stats clean up and enhancements.
> > 
> > Sergey Senozhatsky (8):
> >   zram: drop `init_done' struct zram member
> >   zram: do not pass rw argument to __zram_make_request()
> >   zram: remove good and bad compress stats
> >   zram: use atomic64_t for all zram stats
> >   zram: remove zram stats code duplication
> >   zram: report failed read and write stats
> >   zram: drop not used table `count' member
> >   zram: move zram size warning to documentation
> > 
> >  Documentation/blockdev/zram.txt |   5 ++
> >  drivers/block/zram/zram_drv.c   | 175 +++++++++++++---------------------------
> >  drivers/block/zram/zram_drv.h   |  10 +--
> >  3 files changed, 64 insertions(+), 126 deletions(-)
> 
> Great clean up.
> 
> Sergey, Thanks!
> I am looking forward to your next step!

Hello Sergey,

I guess Andrew wouldn't pick this patchset until closing merge window
so I picked up in my zram tree so let's do further work based on it.

https://git.kernel.org/cgit/linux/kernel/git/minchan/linux.git/log/?h=zram-next

Thanks.

-- 
Kind regards,
Minchan Kim
