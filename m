Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaDYLHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:07:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYLHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:07:49 -0400
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <JBottomley@Parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: two small scsi fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 13:09:48 +0200
Message-Id: <1398424190-21325-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, hi James,

these are two simple use after free fixes that fix a regression introduced
by me in the first scsi update for 3.15-rc1.

I've sent them to the scsi list 10 days ago and haven't seen any reply to
them, and I'd hate if they miss -rc3 in addition to -rc2.

