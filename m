Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3E3MNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:13:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16037 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3E3MMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:12:51 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 0/5] scsi: use platform helper macro and wrapper functions  
Date: Thu, 30 May 2013 20:09:41 +0800
Message-ID: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_platform_driver() and paltform{set,get}_drvdata to simpily code,
and patch 2/5 delete unnecessery drvdate set to null.

Kefeng Wang (5):
  scsi: jazz: use module_platform_driver() and
    platform_{set,get}_drvdata
  scsi: sun: use module_platform_driver() and platform_{set,get}_drvdata
  scsi: qlogicpti: use module_platform_driver() and
    platform_{set,get}_drvdata
  scsi: sun3x: use module_platform_driver() and
    platform_{set,get}_drvdata
  scsi: sni: use module_platform_driver() and platform_{set,get}_drvdata

 drivers/scsi/jazz_esp.c   | 17 +++--------------
 drivers/scsi/qlogicpti.c  | 17 +++--------------
 drivers/scsi/sni_53c710.c | 17 +++--------------
 drivers/scsi/sun3x_esp.c  | 16 +++-------------
 drivers/scsi/sun_esp.c    | 19 +++----------------
 5 files changed, 15 insertions(+), 71 deletions(-)

-- 
1.8.2.1


