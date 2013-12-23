Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab3LWQTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:19:10 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43240 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3LWQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:19:09 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] block: blk-mq: support blk_cleanup_queue on mq
Date: Tue, 24 Dec 2013 00:18:55 +0800
Message-Id: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first 2 patches support drain/sync mq queue in blk_cleanup_queue.

The 3rd patch calls blk_cleanup_queue() in removing device path
to fix queue leak problem.

The 4th patch doesn't export blk_mq_free_queue() because the function
is called in release handler of queue kobject, and drivers needn't
to call it.

Thanks,
--
Ming Lei


