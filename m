Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3JXJug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:50:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3JXJuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:50:35 -0400
Date: Thu, 24 Oct 2013 10:50:33 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/11] blk-mq: new multi-queue block IO queueing mechanism
Message-ID: <20131024095033.GU14598@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-11-git-send-email-axboe@kernel.dk>
 <20131024093923.GA19018@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024093923.GA19018@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24 2013, Dave Jones wrote:
> On Thu, Oct 24, 2013 at 10:26:03AM +0100, Jens Axboe wrote:
>  > +static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_ipi = {
>  > +	.attr = {.name = "ipi_redirect", .mode = S_IRUGO | S_IWUGO},
>  > +	.show = blk_mq_hw_sysfs_ipi_show,
>  > +	.store = blk_mq_hw_sysfs_ipi_store,
> 
> Is having this world writable a good idea ?

Good catch, that's a typo (should be S_IWUSR). Will fix up.

-- 
Jens Axboe

