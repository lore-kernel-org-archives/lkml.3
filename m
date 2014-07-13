Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaGMLsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 07:48:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaGMLs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 07:48:28 -0400
Date: Sun, 13 Jul 2014 04:48:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: call rename2 if exists
Message-ID: <20140713114826.GA4800@infradead.org>
References: <20140520092247.GJ17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520092247.GJ17233@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:22:47AM +0200, Miklos Szeredi wrote:
> Linus,
> 
> Please consider applying this patch to 3.15, so we can move forward with adding
> RENAME_NOREPLACE support to filesystems during the next cycle.

Looks like this didn't go anywhere.  Al, can you at least pick this for
3.17?  Even better would be to just merge rename and rename2 to make
everyones life easier..
