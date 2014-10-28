Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaJ1L1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:27:18 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:21398 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaJ1L1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:14 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH 01/11] MAINTANERS: Add AXD as a supported driver
Date: Tue, 28 Oct 2014 11:26:19 +0000
Message-ID: <1414495589-8579-2-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AXD is Audio Processing IP driver that will be added in the following commits

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <alsa-devel@alsa-project.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dab92a78d1d5..b42c7386190e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1826,6 +1826,12 @@ F:	include/uapi/linux/ax25.h
 F:	include/net/ax25.h
 F:	net/ax25/
 
+AXD AUDIO PROCESSING IP DRIVER
+M:	Qais Yousef <qais.yousef@imgtec.com>
+S:	Supported
+F:	Documentation/devicetree/bindings/axd.txt
+F:	drivers/char/axd/
+
 AZ6007 DVB DRIVER
 M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
-- 
2.1.0

