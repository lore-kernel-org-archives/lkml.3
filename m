Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3JFPjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:39:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3JFPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:39:07 -0400
Date: Sun, 6 Oct 2013 09:39:04 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] blk-mq updates
Message-ID: <20131006153904.GC8252@kernel.dk>
References: <20131006152237.612666544@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006152237.612666544@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06 2013, Christoph Hellwig wrote:
> Patch 1 makes sure bios are completed more carefully, fixing the regression
> with the earlier patch from Mike as well as a few issues found during code
> inspection.  Patches 2 and 3 are a split up and better documented version
> of "blk-mq: blk-mq should free bios in pass through case", and the last two
> are minor cleanups.

Looks good, applied! Thanks Christoph.

-- 
Jens Axboe

