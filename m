Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbaGWW4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:56:09 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62958 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbaGWW4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:56:06 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 0/9] block/aio: loop mq conversion and kernel aio
Date: Thu, 24 Jul 2014 06:55:21 +0800
Message-Id: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first 6 patches convert current loop driver into blk-mq, and
loop's scalability can get improved a lot.

The 7th and 8th patches introduce kernel AIO support, most of
is borrow from Dave's work last year, and thanks to ITER_BVEC,
now it is easier to implement kernel AIO now.

The 9th patch uses kernel AIO with O_DIRECT to improve loop's
performance in single thread.

With blk-mq and kernel AIO, both scalability and performance
of loop driver get lot of improvement.

Thanks,

