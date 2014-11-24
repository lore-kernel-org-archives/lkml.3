Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaKXRbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:31:21 -0500
Received: from mout.web.de ([212.227.15.4]:51816 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaKXRbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:31:19 -0500
Message-ID: <54736B59.7040108@users.sourceforge.net>
Date: Mon, 24 Nov 2014 18:31:05 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, trivial@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] Documentation-SCSI: Fix a typo for the word "destroy"
References: <54736422.90409@users.sourceforge.net>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Kx5e8CjQkiI/mM6HeDX8iouHYiGzICIKOrYFzRRtULR3m3eodaX
 RgBZLc7xaf1a80aqD0d5ucq8zuMwWX0MnYu/NFruig+3JdgG+MujB8mKOnPAULHVq5qOkz0
 YmxEEl/PLl4i+LSBoRHOxuC/ELwVJWovBT0TbMf7HzhtaWF5WpOkTy3PZDaHJ65lumzvjj6
 KXcax8O7cnxBT5umOmetw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 17:25:30 +0100

An identifier was corrected in a change log entry because it contained a typo.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 Documentation/scsi/ChangeLog.lpfc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index 2f6d595..24d6508 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -1263,7 +1263,7 @@ Changes from 20040515 to 20040526
 	* Switch from using internal bus/id/lun to similar data from
 	  scsi_device structure.
 	* Eliminate one-line function lpfc_find_target()
-	* Added slave_alloc, slave_destory
+	* Added slave_alloc, slave_destroy
 	* lpfc_scsi_cmd_start can now acquire lun pointer from
 	  scsi_device->hostdata, which is setup in slave_alloc.
 	* Eliminate unnecessary checking on every cmd just to see if we
-- 
2.1.3

