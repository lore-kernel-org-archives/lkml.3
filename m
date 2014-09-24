Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaIXPDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:03:07 -0400
Received: from verein.lst.de ([213.95.11.211]:53805 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbaIXPDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:03:04 -0400
Date: Wed, 24 Sep 2014 17:03:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] blk-mq: handle failure path for initializing
	hctx
Message-ID: <20140924150302.GA10612@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-10-git-send-email-ming.lei@canonical.com> <20140924102225.GD19078@lst.de> <5422D275.8060300@kernel.dk> <CACVXFVMGvW0m-F_SwFgbNzbe8Zbzw4gq6_aLwi-QpyvyxKr=zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMGvW0m-F_SwFgbNzbe8Zbzw4gq6_aLwi-QpyvyxKr=zg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:01:00PM +0800, Ming Lei wrote:
> Without this one, patch 10 becomes quite ugly.
> 
> OK, I will split this one from this patchset.

I should just be patch 1 of the series so that Jens can merge it ASAP.
