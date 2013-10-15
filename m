Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab3JORSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:18:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab3JORSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:18:52 -0400
Date: Tue, 15 Oct 2013 10:18:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20131015171850.GA26277@infradead.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <20130821130231.GG13330@kvack.org>
 <20131014150701.GA21529@infradead.org>
 <20131014212910.GA31920@kvack.org>
 <20131015165520.GA13021@infradead.org>
 <20131015171447.GE31920@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015171447.GE31920@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 01:14:47PM -0400, Benjamin LaHaise wrote:
> > While I agree that getting that would be useful it is something that has
> > nothing to do with issueing aio from kernel space and holding this
> > patchset hostage for something you'd like to see but that was
> > complicated enough that no one even tried it for many years seems
> > entirely unreasonable.
> > 
> > If there are any other issues left that I have missed it would be nice
> > to get a pointer to it, or a quick brief.
> 
> The item I was refering to is to removing the opcodes used for in-kernel 
> purposes from out of the range that the userland accessible opcodes can 
> reach.  That is, put them above the 16 bit limit for userspace opcodes.  
> There is absolutely no reason to expose kernel internal opcodes via the 
> userspace exported includes.  It's a simple and reasonable change, and I 
> see no reason for Dave not to make that modification.  Until that is 
> done, I will nak the changes.

Oh, missed that.  I totally agree that it needs to be done.

Dave, will you have time to do it soon or should I look into it myself?
