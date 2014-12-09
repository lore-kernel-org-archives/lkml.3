Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaLIP5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:57:12 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:55707 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaLIP5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:57:11 -0500
Message-ID: <54871BD0.8020305@acm.org>
Date: Tue, 09 Dec 2014 16:57:04 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Six blk-mq patches
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While testing the SRP initiator multichannel patches that are present in 
Linus' tree and that will be included in kernel 3.19 I came up with 
several blk-mq patches. Some of these patches fix bugs I encountered 
while running SRP tests; other patches are the result of source reading. 
As usual feedback is welcome.

The patches included in this series are:

0001-blk-mq-Fix-a-use-after-free.patch
0002-blk-mq-Avoid-that-__bt_get_word-wraps-multiple-times.patch
0003-blk-mq-Fix-a-race-between-bt_clear_tag-and-bt_get.patch
0004-blk-mq-Avoid-that-I-O-hangs-in-bt_get.patch
0005-blk-mq-Use-all-available-hardware-queues.patch
0006-blk-mq-Micro-optimize-bt_get.patch

Bart.
