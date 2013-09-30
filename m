Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3I3N0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13029 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3I3N0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:18 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-59-52497bf9dfbd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 00/14] skd: various fixes/cleanups
Date: Mon, 30 Sep 2013 15:25:41 +0200
Message-id: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jAd2f1Z5BBqs38Vn09pxkt1h9t5/N
	YuOM9awWZ39dZbE42/SG3eLyrjlsDmwel8+Werzfd5XNo2/LKkaPO+c+MHl83iQXwBrFZZOS
	mpNZllqkb5fAlXFl/wXWgjaOit3HBRsYj7F1MXJySAiYSKy8+JARwhaTuHBvPVCci0NIYBGj
	xIvOTnYIp4tJYtWpB8wgVWwCVhIT21eBdYgICEvs72hlASliFmhilNi4ZA7YWGEBI4nuqX9Y
	QWwWAVWJ5ofPmEBsXgEPiXn330Gtlpd4er+PbQIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnp
	esn5uZsYwaHxTGoH48oGi0OMAhyMSjy8E5Z7BAmxJpYVV+YeYpTgYFYS4RUv8wwS4k1JrKxK
	LcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwCiyvUrTtDaIQZBn5lXd
	/9c2r6lakXE5UOt5mzlLcb6HgX78jZ+LRc12TMgxM2ut3vFqV57lFLH7/IsbFlxgK722IteE
	YUaul1CWQO52pSW/t55corDlw2NVw+BWsba+RbddvrnPO6FYO+lUzIHm+Z9uhBbv7M14Uvi/
	bGL78/Cjxl6t9qcy9ZRYijMSDbWYi4oTAZYaf2MJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a bunch of fixes/cleanups for the new skd driver.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

Bartlomiej Zolnierkiewicz (14):
  skd: fix unregister_blkdev() placement
  skd: fix error paths in skd_init()
  skd: fix error messages in skd_init()
  skd: alloc flush slab only if some devices are present
  skd: register block device only if some devices are present
  skd: remove SCSI subsystem specific includes
  skd: use <asm/unaligned.h>
  skd: remove redundant skdev->pdev assignment from skd_pci_probe()
  skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
  skd: cleanup skd_do_inq_page_da()
  skd: reorder construct/destruct code
  skd: reorder skd_flush_cmd_[en,de]queue() code
  skd: fix formatting in skd_s1120.h
  skd: remove skd_bio code

 drivers/block/skd_main.c  | 1015 ++++++++++++---------------------------------
 drivers/block/skd_s1120.h |  244 +++++------
 2 files changed, 367 insertions(+), 892 deletions(-)

-- 
1.8.2.3

