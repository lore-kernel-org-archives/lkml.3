Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3JXJkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3JXJkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:40:00 -0400
Date: Thu, 24 Oct 2013 05:39:23 -0400
From: Dave Jones <davej@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/11] blk-mq: new multi-queue block IO queueing mechanism
Message-ID: <20131024093923.GA19018@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	hch@infradead.org
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-11-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-11-git-send-email-axboe@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:26:03AM +0100, Jens Axboe wrote:
 > +static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_ipi = {
 > +	.attr = {.name = "ipi_redirect", .mode = S_IRUGO | S_IWUGO},
 > +	.show = blk_mq_hw_sysfs_ipi_show,
 > +	.store = blk_mq_hw_sysfs_ipi_store,

Is having this world writable a good idea ?

	Dave

