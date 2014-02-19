Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaBSJ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:59:14 -0500
Received: from mail09.linbit.com ([212.69.161.110]:43616 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaBSJ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:59:08 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix smatch warning
Date: Wed, 19 Feb 2014 10:49:06 +0100
Message-Id: <1392803347-6075-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140218202054.GD25515@kernel.dk>
References: <20140218202054.GD25515@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

After I posted to pull request, we got a report about a smatch warning,
which was not CCed to you or the lkml.

It is not a bug right now, but a mistake that could easily become a bug
as we move forward. Normally I would keep this in my queue until the next
batch. Just to be prepared in case the janitors run smatch on your tree:
Please pull it into for-3.15/drivers.

Andreas Gruenbacher (1):
  drbd: Fix future possible NULL pointer dereference

 drivers/block/drbd/drbd_nl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.9.5
