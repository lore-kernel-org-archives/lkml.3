Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbbA2MRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:17:43 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:41300 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbbA2MRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:17:41 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 0/2] blk-mq: one revert and one blk-mq kobject fix candidate
Date: Thu, 29 Jan 2015 20:17:25 +0800
Message-Id: <1422533847-31726-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 1st patch reverts commit "blk-mq: fix hctx/ctx kobject use-after-free"
(commit 76d697d10769048e) which is wrong and causes scsi regression.

The 2nd patch is another candidate/approach for fixing hctx/ctx kobject
use-after-free.

Sorry for causing the mess, and I am happy to see it fixed by either
Bart Van Assche's fix or this patchset, or other better one.

Thanks,
Ming Lei

