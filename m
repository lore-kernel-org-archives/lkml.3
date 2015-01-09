Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbbAIPyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:54:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:47683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbAIPyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:54:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="438556966"
Date: Fri, 9 Jan 2015 23:54:30 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>
Cc: kbuild-all@01.org, Christoph Hellwig <hch@lst.de>,
        Sumit Saxena <sumit.saxena@avagotech.com>,
        Chaitra Basappa <chaitra.basappa@avagotech.com>,
        Kashyap Desai <kashyap.desai@avagotech.com>,
        Uday Lingala <uday.lingala@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH hch-scsi-queue] megaraid_sas:
 megasas_complete_outstanding_ioctls() can be static
Message-ID: <20150109155430.GA124315@lkp-sb04>
References: <201501092322.aenpxV0o%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501092322.aenpxV0o%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d4e9c4e..031921e7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1698,7 +1698,7 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 * @instance:				Adapter soft state
 *
 */
-void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
+static void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
 {
 	int i;
 	struct megasas_cmd *cmd_mfi;
