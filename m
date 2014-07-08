Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaGHNkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:40:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbaGHNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:40:04 -0400
Date: Tue, 8 Jul 2014 06:40:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] scsi patch queue tree updated
Message-ID: <20140708134003.GA7790@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've pushed out new version of the for-3.17 core and drivers trees:

  git://git.infradead.org/users/hch/scsi-queue.git core-for-3.17
  git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.17

In the core tree the biggest news is the old target infrastructure
removal, in addition a few warnings due to 64-bit LUNs have been fixed,
and the tree has been rebased to 3.16-rc4 to pick up all updates that
went into the Linux 3.16 release candidates.

The drivers-for-3.17 tree is new, and I should have picked up all
properly reviewed patches.

Most notably missing from the drivers tree are the mpt2sas and mpt3sas
series and the scsi_debug update which need a review, and the megaraid
and pm8001 uptdates which need a resend.  Missing from the core tree
is the scsi-mq work that still needs a proper review.

Also notably absent is the flush error handling fix, which still needs a
signoff from James and a proper review.  As far as I'm concerned that
fix should still go into 3.16.
