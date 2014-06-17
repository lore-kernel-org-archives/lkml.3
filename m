Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbaFQKd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:33:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37113 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaFQKdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:33:25 -0400
Date: Tue, 17 Jun 2014 03:33:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block,scsi: convert and handle ERR_PTR from
 blk_get_request
Message-ID: <20140617103323.GA13101@infradead.org>
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
 <1401396529-17275-3-git-send-email-joe.lawrence@stratus.com>
 <x49mwdtvjtm.fsf@segfault.boston.devel.redhat.com>
 <20140603172646.769e90d6@jlaw-desktop.mno.stratus.com>
 <x498upcpn09.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x498upcpn09.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 02:07:02PM -0400, Jeff Moyer wrote:
> Wow, that's a lot more churn than I expected.  ;-) I think you should go
> ahead and repost this patch with the change mentioned above (you can add
> my reviewed-by), and we can revisit this scsi one separately if people
> are interested.

Joe, did you manage to get back to this?
