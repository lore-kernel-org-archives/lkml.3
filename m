Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaBYTzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:55:23 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaBYTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:55:20 -0500
Date: Tue, 25 Feb 2014 11:54:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: sougata <sougata@tuxera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hfsplus: fix longname handling
Message-ID: <20140225195459.GA14147@infradead.org>
References: <1393270107.27792.9.camel@ultrabook>
 <20140224134832.d64b1e76e2d6d8fe5b25598d@linux-foundation.org>
 <530CDA6C.9010008@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530CDA6C.9010008@tuxera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 08:01:16PM +0200, sougata wrote:
> ====> snip <=====
> #define hfs_btree_open hfsplus_btree_open
> #define hfs_btree_close hfsplus_btree_close
> #define hfs_btree_write hfsplus_btree_write
> #define hfs_bmap_alloc hfsplus_bmap_alloc
> #define hfs_bmap_free hfsplus_bmap_free
> #define hfs_bnode_read hfsplus_bnode_read

As far as I understand the history is that some code was at some point
mostly identical between hfsplus and hfs and this made diffing easier,
but Brad would have to answert that.  I don't think there's much point
today where hfs is basically stale legacy code and hfsplus gets all the
development.

