Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaHNSxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:53:50 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:55443 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbaHNSxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:53:49 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-8f-53ed05bbfcf1
Date: Thu, 14 Aug 2014 15:53:42 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>
Subject: [GIT PULL for 3.17-rc1] EDAC updates for next
Message-id: <20140814155342.40ac3582.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e9wsO5u1rfBBut/GljMWb+GzeLCqQYm
	i8u75rBZPOp7y+7A4nFixm8Wj8+b5AKYorhsUlJzMstSi/TtErgyLv1/wVRwiKvi18E3zA2M
	izm6GDk5JARMJFYfWcIIYYtJXLi3nq2LkYtDSGAJo8SOI/OZIZxmJomJh9eygFSxCKhKTDh9
	BqyDTcBI4lVjCyuILQJkf35xBcxmFljIKHH8bTqILSxgJvGq9TsziM0rYCXR8342E8Q2Z4mf
	MycxQsQFJX5MvscC0aslsXlbE9QceYnNa94yT2Dkm4WkbBaSsllIyhYwMq9iFC0tTi4oTkrP
	NdIrTswtLs1L10vOz93ECAm94h2MLzZYHWIU4GBU4uGdcPRNsBBrYllxZe4hRgkOZiUR3oa/
	QCHelMTKqtSi/Pii0pzU4kOMTBycUg2M3lJvF761jslstp+8W+rSqznsNp9WfRLTsg5MfRVY
	bDgh8f/jIxemLnouFPnJMeF4pfcmbgdDDaXCf/cidV4/8zp9TONHCPOCHU2tZW8WSR0//6Lm
	x+mEH4d9m6dnHPywpTapdFXTok1JAitehv6bGBqruUM3qUIzb+M2F+7YlDRGY1Wzyne5SizF
	GYmGWsxFxYkAGq40exsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

for you to fetch changes up to 50d1bb93672fa2f42cec6e06ce799fbe864f57e9:

  sb_edac: add support for Haswell based systems (2014-06-26 15:47:01 -0300)

----------------------------------------------------------------
Aristeu Rozanski (10):
      sb_edac: make memory type detection per memory controller
      sb_edac: make node id retrieval per model
      sb_edac: make RIR limit retrieval per model
      sb_edac: search devices using product id
      sb_edac: update Kconfig description
      sb_edac: fix socket detection on Ivy Bridge controllers
      sb_edac: make minimal use of channel_mask
      sb_edac: remove bogus assumption on mc ordering
      edac: add DDR4 and RDDR4
      sb_edac: add support for Haswell based systems

Mauro Carvalho Chehab (1):
      sb_edac: Fix mix tab/spaces alignments

 drivers/edac/Kconfig         |   4 +-
 drivers/edac/edac_mc_sysfs.c |   4 +-
 drivers/edac/sb_edac.c       | 810 +++++++++++++++++++++++++++++--------------
 include/linux/edac.h         |   5 +
 4 files changed, 551 insertions(+), 272 deletions(-)

