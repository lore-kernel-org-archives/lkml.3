Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3JAMF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:05:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3JAMFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:05:55 -0400
Date: Tue, 1 Oct 2013 05:05:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: axboe@kernel.dk, abhansali@stec-inc.com, jmoyer@redhat.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] skd: remove SCSI subsystem specific includes
Message-ID: <20131001120548.GA25111@infradead.org>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
 <1380547556-17719-7-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380547556-17719-7-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 03:25:47PM +0200, Bartlomiej Zolnierkiewicz wrote:
> This is not a SCSI host driver so remove SCSI subsystem specific
> includes.

The sad thing is that it is a driver for a device speaking SCSI, but for
some reason that was never discussed it is written to the block layer.

