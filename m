Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3JITEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:04:23 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:54366 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3JITEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:04:20 -0400
Message-ID: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
Subject: scsi-mq updated to latest linux-block/new-queue
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Alexander Gordeev <agordeev@redhat.com>
Date: Wed, 09 Oct 2013 12:12:51 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Just a heads up that the scsi-mq alpha branch has been updated to Jen's
latest linux-block/new-queue containing hch's recent blk-mq
improvements, along with Alexander's patch for the is_flush_fua +
queue_depth=1 bug.

The branch @ v3.12-rc3 is available here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/log/?h=scsi-mq

The main changes include dropping all of the blk_mq_alloc_request() +
blk_mq_free_request() changes that are now unnecessary with hch's
improvements in place, along with other miscellaneous cleanups.

--nab



