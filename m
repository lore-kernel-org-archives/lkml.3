Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbbANKcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:32:41 -0500
Received: from [85.220.129.38] ([85.220.129.38]:53599 "EHLO smtp3-1.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbbANKci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:32:38 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 05:32:38 EST
X-Spam-Flag: NO
X-Spam-Score: -2.801
Date: Wed, 14 Jan 2015 11:25:49 +0100
From: poeschel@lemonage.de
To: gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, sandeep_n@ti.com,
        kheitke@codeaurora.org, bp@suse.de, johannes.thumshirn@men.de,
        andreas.noever@gmail.com, linux-kernel@vger.kernel.org
Cc: Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH RESEND] drivers/Kconfig: remove duplicate entry for soc
Message-ID: <20150114102549.GA25803@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: KMail/4.14.1 (Linux/3.16.0-4-amd64; KDE/4.14.2; x86_64; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

For some reason there was the same menu entry in menuconfig twice. This
trivial patch leaves the one that is older as is and removes the other
entry.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Gentle ping on this one. It already got one ack from Borislav.

 drivers/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3..5add358 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -132,8 +132,6 @@ source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
-- 
2.1.3
