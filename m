Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3KHTe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:34:29 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab3KHTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:34:27 -0500
Date: Fri, 8 Nov 2013 11:34:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ben Myers <bpm@sgi.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, elder@kernel.org,
        Mark Tinguely <tinguely@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: XFS leadership and a new co-maintainer candidate
Message-ID: <20131108193424.GA11052@infradead.org>
References: <20131107220208.GY1935@sgi.com>
 <527C0F64.3010906@sgi.com>
 <527C4B27.6020205@redhat.com>
 <527CC50D.4060905@redhat.com>
 <20131108180337.GO10553@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108180337.GO10553@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:03:37PM -0600, Ben Myers wrote:
> Mark is replacing Alex as my backup because Alex is really busy at
> Linaro and asked to be taken off awhile ago.  The holiday season is
> coming up and I fully intend to go off my meds, turn in to Fonzy the
> bear, and eat my hat.  I need someone to watch the shop while I'm off
> exploring on Mars.  I trust Mark to do that because he is totally
> awesome.


Doing this as an unilateral decisions is not something that will win you
a fan base.

While we never had anything reassembling a democracy in Linux Kernel
development making decisions without even contacting the major
contributor is wrong, twice so if the maintainer is a relatively minor
contributor to start with.

Just because it recent came up elsewhere I'd like to recite the
definition from Trond here again:

	http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000066.html

By many of the creative roles enlisted there it's clear that Dave should
be the maintainer.  He's been the main contributor and chief architect
for XFS for many year, while the maintainers came and went at the mercy
of SGI.  This is not meant to bad mouth either of you as I think you're
doing a reasonably good job compared to other maintainers, but at the
same time the direction is set by other people that have a much longer
involvement with the project, and having them officially in control
would help us forward a lot.  It would also avoid having to spend
considerable resources to train every new generation of SGI maintainer.

Coming to and end I would like to maintain Dave Chinner as the primary
XFS maintainer for all the work he has done as biggest contributor and
architect of XFS since longer than I can remember, and I would love to
retain Ben Myers as a co-maintainer for all the good work he has done
maintaining and reviewing patches since November 2011.

I would also like to use this post as a public venue to condemn the
unilateral smokey backroom decisions about XFS maintainership that
SGI is trying to enforce on the community.
