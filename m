Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3J2XFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab3J2XE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:04:59 -0400
Date: Tue, 29 Oct 2013 19:04:30 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, tj@kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 17/23] dm: Refactor for new bio cloning/splitting
Message-ID: <20131029230430.GA2989@redhat.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
 <1383077896-4132-18-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383077896-4132-18-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29 2013 at  4:18pm -0400,
Kent Overstreet <kmo@daterainc.com> wrote:

> We need to convert the dm code to the new bvec_iter primitives which
> respect bi_bvec_done; they also allow us to drastically simplify dm's
> bio splitting code.
> 
> Also kill bio_sector_offset(), dm was the only user and it doesn't make
> much sense anymore.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com

I reviewed this patch some weeks ago (along with the rest of the DM
changes), I provided the dm-thin.c changes in this patch:
http://www.redhat.com/archives/dm-devel/2013-October/msg00027.html

Please add:

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
