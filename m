Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaJUMG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:06:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaJUMG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:06:56 -0400
Date: Tue, 21 Oct 2014 05:06:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <ooo@electrozaur.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, osd-dev@open-osd.org
Subject: state of the osdblk driver?
Message-ID: <20141021120653.GA9530@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The osdblk driver hsa seen literally no change except for global
API changes since it was merged, and I've never heard of a user.

Is this something we want to keep around?  I just noticed it because
it's the only non-SCSI user of some of the old block layer tagging
functions.
