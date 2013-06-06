Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3FFVBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:01:19 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49352 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab3FFVBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:01:18 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2013 17:01:18 EDT
From: Laura Lawniczak <laura.lawniczak@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 1/1] keucr: restored lost line
Date: Thu,  6 Jun 2013 22:50:51 +0200
Message-Id: <1370551851-13456-2-git-send-email-laura.lawniczak@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370551851-13456-1-git-send-email-laura.lawniczak@googlemail.com>
References: <20130606201631.GB14773@kroah.com>
 <1370551851-13456-1-git-send-email-laura.lawniczak@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This line was unfortunately removed during patch process. This caused an
"unused variable" warning and may cause other unintended effects.
So here it is again.

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
---
 drivers/staging/keucr/transport.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 1f9ea58..c47a035 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -131,6 +131,7 @@ static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
 		break;
 	}
 	bn = 0;
+	blen = 0;
 }
 
 /*
-- 
1.7.10.4

