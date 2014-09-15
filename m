Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbaIOW6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:58:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaIOW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:58:19 -0400
Date: Mon, 15 Sep 2014 15:58:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] scsi patch queue tree updated
Message-ID: <20140915225818.GA11869@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801122042.GA10771@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

I've pushed two updates to the core-for-3.17 branch of

    git://git.infradead.org/users/hch/scsi-queue.git

which should go to Linus before the next rc.

One is a regression fix for drivers using block layer tagging when
not using blk-mq introduced in the blk-mq series, and the other
fixes a potential buffer overrun in the iscsi initiator.

Updates of the for-3.18 trees will follow soon.
