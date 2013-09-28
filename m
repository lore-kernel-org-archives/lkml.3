Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3I1Nzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:55:31 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3I1Nz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:55:29 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: UBI fastmap updates
Date: Sat, 28 Sep 2013 15:55:09 +0200
Message-Id: <1380376516-30144-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this series is a collection of all pending UBI fastmap updates.

Richard Genoud found issues in combination with U-Boot.
These issues also uncovered other minor issues in some error paths.
Only one fix is not really fastmap specific and touches generic 
UBI code, "UBI: simplify image sequence test".

Thanks,
//richard

Richard Genoud (2):
      UBI: fastmap: fix backward compatibility with image_seq
      UBI: simplify image sequence test

Richard Weinberger (5):
      UBI: fix refill_wl_user_pool()
      UBI: Fix error path in scan_pool()
      UBI: Call scan_all() with correct offset in error case
      UBI: Fix memory leak in ubi_attach_fastmap() error path
      UBI: Add some asserts to ubi_attach_fastmap()

 drivers/mtd/ubi/attach.c  | 11 ++++++-----
 drivers/mtd/ubi/fastmap.c | 41 +++++++++++++++++++++++++++++++++++++----
 drivers/mtd/ubi/wl.c      |  4 ----
 3 files changed, 43 insertions(+), 13 deletions(-)
