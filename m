Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaHDEHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:07:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19108 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaHDEHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:07:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 03 Aug 2014 20:58:27 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] MAINTAINERS: update GPIO include files
Date: Mon, 4 Aug 2014 13:06:58 +0900
Message-ID: <1407125218-22026-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Files under include/linux/gpio/ were not reported as part of the GPIO
subsystem. Fix this.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e0d24dcb122..d9ca71a31101 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4031,7 +4031,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
 S:	Maintained
 F:	Documentation/gpio/
 F:	drivers/gpio/
-F:	include/linux/gpio*
+F:	include/linux/gpio/
+F:	include/linux/gpio.h
 F:	include/asm-generic/gpio.h
 
 GRE DEMULTIPLEXER DRIVER
-- 
2.0.3

