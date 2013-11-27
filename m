Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab3K0BIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:08:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3K0A76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:58 -0500
Date: Tue, 26 Nov 2013 17:59:54 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [GIT PULL] Immutable biovecs
Message-ID: <20131127005954.GH9759@kernel.dk>
References: <20131125215216.GB21515@kmo>
 <20131126060558.GA6434@infradead.org>
 <20131127004422.GB21305@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127004422.GB21305@kmo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26 2013, Kent Overstreet wrote:
> On Mon, Nov 25, 2013 at 10:05:58PM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 25, 2013 at 01:52:16PM -0800, Kent Overstreet wrote:
> > > Jens - here's immutable biovecs, rebased and ready for 3.14. Changes since the
> > > last version of the series:
> > 
> > Can you do a resend of the patch series to all involved lists first so
> > we can have a detailed look at the current version?
> 
> Sure thing.
> 
> > >  * bio_clone_bioset() retains the old behaviour, as previously discussed -
> > >    bio_clone_fast() is being used by bcache, dm and the new bio_split().
> > 
> > Any chance to have a more descriptive name than bio_clone_fast?  Also
> > without having the actual patches in front of me, did you make sure to
> > document the different in semantics in detail?
> 
> I haven't been able to think of anything I don't hate, I'm open to
> suggestions.

Don't think it's super important, as it will die off pretty quickly
anyway. _fast implies it takes certain shortcuts and you need to be more
careful, so I don't think it's that bad.

-- 
Jens Axboe

