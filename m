Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaGZPDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:03:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaGZPDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:03:22 -0400
Date: Sat, 26 Jul 2014 08:03:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org
Subject: Re: VFS tree for 3.17?
Message-ID: <20140726150321.GA9230@infradead.org>
References: <20140716114136.GA25237@infradead.org>
 <20140722162455.GA15053@infradead.org>
 <20140724153057.GA1584@infradead.org>
 <CAJfpeguYamZTcdUCZ6+7E=MxQnapF5xE+biOTnhdTQ_V7J1yZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguYamZTcdUCZ6+7E=MxQnapF5xE+biOTnhdTQ_V7J1yZw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 06:35:24PM +0200, Miklos Szeredi wrote:
> overlayfs?  I think it's mature enough, but I thought that a year ago,
> and there's been a format change since then...  So how do people feel?

Even if I had reviewed it recently I wouldn't pull in something that
large without wainting for Al to reappear.

