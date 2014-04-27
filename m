Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaD0Bg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 21:36:57 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:55693 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaD0Bg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 21:36:56 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/6] staging: comedi: addi_apci_1564: remove unnecessary include
Date: Sat, 26 Apr 2014 20:36:44 -0500
Message-Id: <1398562604-5554-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This include is no longer needed.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index df8833b..c84e17c 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -3,7 +3,6 @@
 
 #include "../comedidev.h"
 #include "comedi_fc.h"
-#include "amcc_s5933.h"
 
 #include "addi-data/addi_common.h"
 
-- 
1.9.0

