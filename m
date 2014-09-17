Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaIQJsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:48:10 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35320 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaIQJsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:48:08 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/2] blk-mq: fix race between timeout and queue_rq
Date: Wed, 17 Sep 2014 17:47:56 +0800
Message-Id: <1410947278-15733-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch trys to fix one race between timeout and queue_rq.

And the second one removes two unnecessary blk_clear_rq_complete().

Thanks,
--
Ming Lei

