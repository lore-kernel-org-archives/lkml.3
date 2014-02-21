Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbaBUQ6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:58:31 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54802 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaBUQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:58:27 -0500
Date: Fri, 21 Feb 2014 08:58:23 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] next round of blk-mq updates
Message-ID: <20140221165823.GE30251@kernel.dk>
References: <20140220233235.443299098@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220233235.443299098@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20 2014, Christoph Hellwig wrote:
> A couple more blkmq updates: a trivial cleanup, a consolidation of two very
> similar functions into one, and support for partial request completions,
> a feature needed by the work in progress scsi blk-mq support.

Thanks, applied all 3. The end_io is a bit fatter than it was before,
which is a shame. But on the plus side, it's consistent...

-- 
Jens Axboe

