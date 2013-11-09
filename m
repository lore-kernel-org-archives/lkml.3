Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3KIIch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 03:32:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3KIIc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 03:32:26 -0500
Date: Sat, 9 Nov 2013 00:32:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the userns tree
Message-ID: <20131109083215.GA12574@infradead.org>
References: <20131108175848.6ca49f0ee8fe2a6c1125394a@canb.auug.org.au>
 <20131108072732.GA27537@infradead.org>
 <87ob5uwlrx.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob5uwlrx.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 02:50:42PM -0800, Eric W. Biederman wrote:
> Al was watching the conversation so I assumed that no answer to that
> request was sufficient to take these patches in my tree.
>
> I fully intend to take responsibility for these patches and work through
> whatever issues they have, and I intend to send Linus my pull request.
> As such dropping the userns tree from linux-next seems inappropriate.
> 

It's not.  Really, if you do touch core code and do not get a maintainer
respone it surely does not mean you can merge it through your tree.

It usually either means this stuff is so bad that it's not even worth
responding to or that the maintainer and core revierers of the area
are busy.  In this case it's probably a combination of both.

> Eric
---end quoted text---
