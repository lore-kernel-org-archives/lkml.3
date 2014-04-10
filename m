Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169AbaDJKBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:01:49 -0400
Received: from verein.lst.de ([213.95.11.211]:60200 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935017AbaDJKBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:01:47 -0400
Date: Thu, 10 Apr 2014 12:01:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct
	blk_mq_tags
Message-ID: <20140410100144.GB20342@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de> <53457404.5070800@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53457404.5070800@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:23:32AM -0600, Jens Axboe wrote:
> This should go into block/blk-mq-tag.h.

Ok.

> We might as well leave this, the mtip32xx conversion ends up using it. So 
> if we pull it now, it'll just be reintroduced shortly.

It's back in the latest revision of the patch, just taking a
struct blk_mq_tag pointer now so that it can be used by SCSI as well.

I've also changed an opencode variant of it to use the helper.

Pointer: http://git.infradead.org/users/hch/scsi.git/commitdiff/b0f1ed35bbeb6d0177fc0cc0bf5c880c3c5d1817

