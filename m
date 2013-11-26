Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3KZGKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:10:21 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3KZGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:10:19 -0500
Date: Mon, 25 Nov 2013 22:10:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/5] mtip32xx: handle arbitrary size bios
Message-ID: <20131126061018.GC6434@infradead.org>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
 <1385418633-9753-3-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385418633-9753-3-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 02:30:30PM -0800, Kent Overstreet wrote:
> We get a measurable performance increase by handling this in the driver when
> we're already looping over the biovec, instead of handling it separately in
> generic_make_request() (or bio_add_page() originally)

Given that Jens has a patch queue up to convert the driver to blk-mq
adjusting the blk-mq infrastructure to handle this might be a better
plan forward..

