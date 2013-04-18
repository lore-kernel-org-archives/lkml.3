Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967092Ab3DRObM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:31:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47183
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965816Ab3DRObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:31:11 -0400
Date: Thu, 18 Apr 2013 07:30:14 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130418143014.GZ4816@kernel.dk>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk>
 <516FFFAC.8040103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516FFFAC.8040103@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18 2013, Wanlong Gao wrote:
> On 04/18/2013 09:35 PM, Jens Axboe wrote:
> > On Thu, Apr 18 2013, Wanlong Gao wrote:
> >>> A bio is always fully initialized, regardless of which internal
> >>> allocator it came from. If people are doing private kmallocs, then they
> >>> better be using bio_init() as well.
> >>>
> >>> Wanlong, would it be possible to get a full dmesg on boot see I can see
> >>> what drivers and file systems are in use? Anything special about your
> >>> setup.
> >>
> >> Sure, attached.
> > 
> > Does the below help?
> 
> Still got panic with this patch. :-(

Could you capture the full dump? I'd like to see what rcx was, and that
seems to have scrolled off.

-- 
Jens Axboe

