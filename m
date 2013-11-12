Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3KLRdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:33:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3KLRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:32:59 -0500
Date: Tue, 12 Nov 2013 09:32:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ben Myers <bpm@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, elder@kernel.org,
        Mark Tinguely <tinguely@sgi.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: XFS leadership and a new co-maintainer candidate
Message-ID: <20131112173253.GA15089@infradead.org>
References: <20131107220208.GY1935@sgi.com>
 <527C0F64.3010906@sgi.com>
 <527C4B27.6020205@redhat.com>
 <527CC50D.4060905@redhat.com>
 <20131108180337.GO10553@sgi.com>
 <20131108193424.GA11052@infradead.org>
 <20131108204605.GA1935@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108204605.GA1935@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 02:46:06PM -0600, Ben Myers wrote:
> That really didn't happen Christoph.  It's not in my tree or in a pull request.

I'll take my back room complain back then, but I still think that this
is not a useful way to discuss something like this.

> Linus, let me know what you want to do.  I do think we're doing a fair job over
> here, and (geez) I'm just trying to add Mark as my backup since Alex is too
> busy.  I know the RH people want more control, and that's understandable, but
> they really don't need to replace me to get their code in.  Ouch.

I'd really like to see more diversity in XFS maintainers.  The SGI focus
has defintively been an issue again and again because it seems when one
SGI person is too busy the others usually are as well. As mentioned
before there's also been historically a way too high turnover, with the
associated transition pains.

By making sure we have a broader base for the maintainers, and a more
open infrastructure we'll all win.  Note that we already had that sort
of instructure on kernel.org, but gave up on it because many people
perceived the effort to re-gain the kernel.org accounts to high.

I would also really like to get a clarification on "I know the RH people
want more control, and that's understandable, but they really don't need
to replace me to get their code in".  What specific people are you
worried about an what code?  What makes "the RH people" less worthy
to their code in than "the SGI" people.
