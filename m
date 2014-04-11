Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaDKHdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:33:42 -0400
Received: from verein.lst.de ([213.95.11.211]:36327 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbaDKHdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:33:40 -0400
Date: Fri, 11 Apr 2014 09:33:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <m@bjorling.me>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct
	blk_mq_tags
Message-ID: <20140411073336.GA26328@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de> <53457404.5070800@fb.com> <20140410100144.GB20342@lst.de> <53475693.7050609@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53475693.7050609@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:42:27PM -0600, Jens Axboe wrote:
> Great. Will you send out an updated patchset?

I was waiting for you to apply the previous series, but I'll just resend my
whole set of outstanding patches, it'll need a bit of rebasing against
your updated tree anyway.

