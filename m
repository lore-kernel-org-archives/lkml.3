Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaC2S3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:29:04 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58923 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaC2S3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:29:02 -0400
Date: Sat, 29 Mar 2014 23:59:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 40/55] scsi: Mark function as static in qla2xxx/qla_nx.c
Message-ID: <9d5974b237aa399b5d979609904c6b212206831f.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in qla2xxx/qla_nx.c because it is not used
outside this file.

This eliminates the following warning in qla2xxx/qla_nx.c:
drivers/scsi/qla2xxx/qla_nx.c:2292:1: warning: no previous prototype for ‘qla82xx_set_idc_version’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 1e6ba4a..cf49b39 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2288,7 +2288,7 @@ void qla82xx_init_flags(struct qla_hw_data *ha)
 	ha->nx_legacy_intr.pci_int_reg = nx_legacy_intr->pci_int_reg;
 }
 
-inline void
+static inline void
 qla82xx_set_idc_version(scsi_qla_host_t *vha)
 {
 	int idc_ver;
-- 
1.7.9.5

