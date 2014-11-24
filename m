Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaKXRJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:09:21 -0500
Received: from mout.web.de ([212.227.17.12]:50474 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaKXRJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:09:20 -0500
Message-ID: <54736610.9090203@users.sourceforge.net>
Date: Mon, 24 Nov 2014 18:08:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "James E. J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, intel-linux-scu@intel.com
CC: kernel-janitors@vger.kernel.org, trivial@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] isci: Fix a typo for the word "destroy"
References: <54736422.90409@users.sourceforge.net>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:bmIiacscA6WkxbvuvPJkhq9aET2dNgm4Sv7/EKCmSDED+lyjE0g
 XzrHvccSbFFKNYLjHoZ6z9jUjJHb1PAiUmU91lyH040Yo0nl+yH5pIXkn0jlx/wWrQR+z+8
 akokk+MyLPF0lw/vWwk0xEE1EPGdwa4bA/Jc3ivNcSdRiw8c4+/65xhQqP0EcFbCSUTqaj6
 bfSCIEGbo06SBsf7BXIag==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 15:35:48 +0100

A word was corrected in the description for
the sci_remote_device_destruct() function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/isci/remote_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index cc51f38..f54bb98 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1008,7 +1008,7 @@ static void sci_remote_device_initial_state_enter(struct sci_base_state_machine
  * successfully destructed or if some failure occurred. enum sci_status This value
  * is returned if the device is successfully destructed.
  * SCI_FAILURE_INVALID_REMOTE_DEVICE This value is returned if the supplied
- * device isn't valid (e.g. it's already been destoryed, the handle isn't
+ * device isn't valid (e.g. it's already been destroyed, the handle isn't
  * valid, etc.).
  */
 static enum sci_status sci_remote_device_destruct(struct isci_remote_device *idev)
-- 
2.1.3

