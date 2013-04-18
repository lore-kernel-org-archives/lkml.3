Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3DRSNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:13:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48321
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab3DRSNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:13:40 -0400
Date: Thu, 18 Apr 2013 11:13:18 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130418181318.GH4816@kernel.dk>
References: <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk>
 <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk>
 <CA+55aFwA8njGh4v8ZfR_o4s4m=Hugnadeir=uxbeE4yxHiBKLg@mail.gmail.com>
 <20130418172732.GB9897@mtj.dyndns.org>
 <20130418173811.GF4816@kernel.dk>
 <20130418180752.GD9897@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418180752.GD9897@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18 2013, Tejun Heo wrote:
> On Thu, Apr 18, 2013 at 10:39:00AM -0700, Jens Axboe wrote:
> > > If I'm not mistaken, it seems like we have a bio which has 1 as its
> > > ->bi_bdev.  Ummm.... no idea whatsoever how that can happen tho right
> > > now.  Looking into it.
> > 
> > Yep, thanks Linus for that hint... Must be someone abusing it for a
> > flag field post submission? Crazy.
> 
> Let's hope that's not the case because there'll be blood if it is. :)

Yeah, it's beyond the amount of crazy I've come to expect from various
random users of IO interfaces :-)

-- 
Jens Axboe

