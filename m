Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaK0QNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:13:38 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33083 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaK0QNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:13:36 -0500
Message-ID: <54774D8D.2030204@gmail.com>
Date: Thu, 27 Nov 2014 17:13:01 +0100
From: Boris Bodemann <bobo.barbarossa@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, trivial@kernel.org
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/1] esas2r: Correct typos of "validate" in a comment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Bodemann <bobo.barbarossa@gmail.com>

Correct typos of "validate" in a comment

Signed-off-by: Boris Bodemann <bobo.barbarossa@gmail.com>
---
diff -up a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
--- a/drivers/scsi/esas2r/esas2r_flash.c        2014-11-21 18:24:10.000000000 +0100
+++ b/drivers/scsi/esas2r/esas2r_flash.c        2014-11-27 14:49:03.029899303 +0100
@@ -684,9 +684,9 @@ static u16 calc_fi_checksum(struct esas2
  *              1)  verify the fi_version is correct
  *              2)  verify the checksum of the entire image.
  *              3)  validate the adap_typ, action and length fields.
- *              4)  valdiate each component header. check the img_type and
+ *              4)  validate each component header. check the img_type and
  *                  length fields
- *              5)  valdiate each component image.  validate signatures and
+ *              5)  validate each component image.  validate signatures and
  *                  local checksums
  */
 static bool verify_fi(struct esas2r_adapter *a,
