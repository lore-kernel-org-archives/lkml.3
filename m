Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaIGPqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 11:46:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaIGPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 11:46:29 -0400
Date: Sun, 7 Sep 2014 08:46:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Daniel Bomar <dbdaniel42@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fixed styling issues
Message-ID: <20140907154625.GA18274@infradead.org>
References: <1410093905-15431-1-git-send-email-dbdaniel42@gmail.com>
 <CAFLxGvwVNTXw1uvzJaTyo6EQNgGWuAnGTi7s2+r3P+zF71zD3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwVNTXw1uvzJaTyo6EQNgGWuAnGTi7s2+r3P+zF71zD3A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 03:16:22PM +0200, Richard Weinberger wrote:
> On Sun, Sep 7, 2014 at 2:45 PM, Daniel Bomar <dbdaniel42@gmail.com> wrote:
> > Fixed styling issues as reported by scripts/checkpatch.pl
> >
> > Signed-off-by: Daniel Bomar <dbdaniel42@gmail.com>
> 
> Please don't run checkpatch.pl on in-kernel files.

I don't think it's up to us to tell people what files they should run
patches on on..  That doesn't mean that pure style cleanup patches in an
area you don't understand are a good idea, so don't send them.  This is
different when you actually do a major overhaul of an area, in which
case I'd actually like to do a first pass of style cleanup and
refactoring before submitting the real work.
