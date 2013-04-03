Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165Ab3DCLrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:47:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58417 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3DCLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:47:30 -0400
Date: Wed, 3 Apr 2013 13:47:22 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [GIT PULL] writeback: convert writeback to unbound workqueue
Message-ID: <20130403114722.GQ4667@kernel.dk>
References: <20130402030933.GB6255@htj.dyndns.org>
 <20130402095353.GB4667@kernel.dk>
 <CAOS58YMfDyomRpGMwmPg1mCU2t7Q0NTrLCuZjmr_YLs=XwrahQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YMfDyomRpGMwmPg1mCU2t7Q0NTrLCuZjmr_YLs=XwrahQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02 2013, Tejun Heo wrote:
> Hello, Jens.
> 
> On Tue, Apr 2, 2013 at 2:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > Thanks, pulled in for testing. We'll need the debug change in before
> > sending this upstream, though. I agree with Jan/Dave that this is
> > required functionality, for debugging purposes.
> 
> Yeah, sure thing. The debug changes are targeting the coming merge
> window but they'll have to go through -mm instead of block or
> workqueue trees due to dependencies on arch changes.  So, AFAICS,
> while the routing is rather complicated, things should fall in place
> in the same merge window.

OK, that will work. Thanks, Tejun.

-- 
Jens Axboe

