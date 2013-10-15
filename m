Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab3JOQz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:55:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3JOQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:55:25 -0400
Date: Tue, 15 Oct 2013 09:55:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20131015165520.GA13021@infradead.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <20130821130231.GG13330@kvack.org>
 <20131014150701.GA21529@infradead.org>
 <20131014212910.GA31920@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014212910.GA31920@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:29:10PM -0400, Benjamin LaHaise wrote:
> On Mon, Oct 14, 2013 at 08:07:01AM -0700, Christoph Hellwig wrote:
> > Ben,
> > 
> > are you fine with the series now?  It's been in linux-next for a while
> > and it would be really helpful to get it in for the avarious places
> > trying to do in-kernel file aio without going through the page cache.
> 
> No, I am not okay with it.  The feedback I provided 2 months ago has yet to 
> be addressed.

Maybe I'm missing something, but the only big discussion item was that
you'd want something totally unrelated (notification for blocking)
mashed into this patch set.

While I agree that getting that would be useful it is something that has
nothing to do with issueing aio from kernel space and holding this
patchset hostage for something you'd like to see but that was
complicated enough that no one even tried it for many years seems
entirely unreasonable.

If there are any other issues left that I have missed it would be nice
to get a pointer to it, or a quick brief.

