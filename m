Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3KZGGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:06:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3KZGGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:06:05 -0500
Date: Mon, 25 Nov 2013 22:05:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [GIT PULL] Immutable biovecs
Message-ID: <20131126060558.GA6434@infradead.org>
References: <20131125215216.GB21515@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125215216.GB21515@kmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:52:16PM -0800, Kent Overstreet wrote:
> Jens - here's immutable biovecs, rebased and ready for 3.14. Changes since the
> last version of the series:

Can you do a resend of the patch series to all involved lists first so
we can have a detailed look at the current version?

> 
>  * bio_clone_bioset() retains the old behaviour, as previously discussed -
>    bio_clone_fast() is being used by bcache, dm and the new bio_split().

Any chance to have a more descriptive name than bio_clone_fast?  Also
without having the actual patches in front of me, did you make sure to
document the different in semantics in detail?

>  * refactoring patches to use submit_bio_wait() and bio_for_each_segment()

Jens already applied the submit_bio_wait patch.  

