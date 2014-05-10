Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaEJRCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:02:07 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47622 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEJRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:02:05 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] blk-mq: bitmap tag: fix and cleanup
Date: Sun, 11 May 2014 01:01:47 +0800
Message-Id: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens and guys,

I just take a look at the new bitmap based tag allocation patches
in -next tree, and play it for a while.

Some of them are fixes, and some of them are cleanup, please
review.

Thanks,
--
Ming Lei


