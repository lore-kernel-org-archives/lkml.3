Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaL2ObU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:31:20 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:25326 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbaL2ObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:31:10 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QAHdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQmjxMBAQEBBiKGA4kQZAcWhBMFjD6KSpFQIoNvPTGBA4FAAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/11 linux-next] [media] tw68: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:39 +0100
Message-Id: <1419863387-24233-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/pci/tw68/tw68.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
index 7a7501b..93f2335 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -25,7 +25,6 @@
  *  GNU General Public License for more details.
  */
 
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <linux/videodev2.h>
 #include <linux/notifier.h>
-- 
2.1.0

