Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3JaOF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:05:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43297 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3JaOFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:05:55 -0400
Date: Thu, 31 Oct 2013 08:05:49 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 17/23] dm: Refactor for new bio cloning/splitting
Message-ID: <20131031140549.GD10091@kernel.dk>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
 <1383077896-4132-18-git-send-email-kmo@daterainc.com>
 <20131030000908.GB2989@redhat.com>
 <20131030001959.GB27129@kmo>
 <20131030002935.GA3449@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030002935.GA3449@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29 2013, Mike Snitzer wrote:
> On Tue, Oct 29 2013 at  8:19pm -0400,
> Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > On Tue, Oct 29, 2013 at 08:09:08PM -0400, Mike Snitzer wrote:
> > > 
> > > But now that I look closer, the above dm-thin.c hunks belong in:
> > > [PATCH 19/23] block: Generic bio chaining
> > > 
> > > Seems these changes were mistakenly folded into this 17/23 patch?
> > 
> > ...Whoops, fixed. Here's the new versions if you want to take a look:
> > 
> > http://evilpiepirate.org/git/linux-bcache.git/log/?h=for-jens
> > http://evilpiepirate.org/git/linux-bcache.git/commit/?h=for-jens&id=74f0f2084f88bb38403ca80bb98976f8219f9262
> 
> Yeap, looks good (aside from the dm patches not having my Reviewed-by).
> 
> Not sure if Jens can add it?..  that said, I don't mind the commits not
> having my Reviewed-by but it does lose some context for your changes
> having had some other eyeballs on them.

I have added it, thanks Mike.

-- 
Jens Axboe

