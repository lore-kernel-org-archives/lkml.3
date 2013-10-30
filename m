Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3J3BYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:24:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3J3BYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:24:03 -0400
Date: Tue, 29 Oct 2013 20:29:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, tj@kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 17/23] dm: Refactor for new bio cloning/splitting
Message-ID: <20131030002935.GA3449@redhat.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
 <1383077896-4132-18-git-send-email-kmo@daterainc.com>
 <20131030000908.GB2989@redhat.com>
 <20131030001959.GB27129@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030001959.GB27129@kmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29 2013 at  8:19pm -0400,
Kent Overstreet <kmo@daterainc.com> wrote:

> On Tue, Oct 29, 2013 at 08:09:08PM -0400, Mike Snitzer wrote:
> > 
> > But now that I look closer, the above dm-thin.c hunks belong in:
> > [PATCH 19/23] block: Generic bio chaining
> > 
> > Seems these changes were mistakenly folded into this 17/23 patch?
> 
> ...Whoops, fixed. Here's the new versions if you want to take a look:
> 
> http://evilpiepirate.org/git/linux-bcache.git/log/?h=for-jens
> http://evilpiepirate.org/git/linux-bcache.git/commit/?h=for-jens&id=74f0f2084f88bb38403ca80bb98976f8219f9262

Yeap, looks good (aside from the dm patches not having my Reviewed-by).

Not sure if Jens can add it?..  that said, I don't mind the commits not
having my Reviewed-by but it does lose some context for your changes
having had some other eyeballs on them.
