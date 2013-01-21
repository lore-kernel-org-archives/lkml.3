Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3AUVOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:14:07 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:57845 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AUVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:14:05 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: linux-pcmcia@lists.infradead.org
Cc: plagnioj@jcrosoft.com, gregkh@linuxfoundation.org, nicolas.ferre@atmel.com,
        wfp5p@virginia.edu, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 2/3] drivers: pcmcia: ds.c fix checkpatch errors
Date: Mon, 21 Jan 2013 22:16:05 +0100
Message-Id: <1358802966-10430-3-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358802966-10430-1-git-send-email-laurent.navet@gmail.com>
References: <1358802966-10430-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix these checkpatch errors :
- ERROR: spaces required around that '<' (ctx:VxW)
- ERROR: "foo * bar" should be "foo *bar"
- WARNING: please, no space before tabs

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/pcmcia/ds.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 2deacbb..04a4b2d 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -81,8 +81,8 @@ static void pcmcia_check_driver(struct pcmcia_driver *p_drv)
 
 
 struct pcmcia_dynid {
-	struct list_head 		node;
-	struct pcmcia_device_id 	id;
+	struct list_head		node;
+	struct pcmcia_device_id		id;
 };
 
 /**
@@ -566,7 +566,7 @@ static struct pcmcia_device *pcmcia_device_add(struct pcmcia_socket *s,
 			c->io[i].name = p_dev->devname;
 			c->io[i].flags = IORESOURCE_IO;
 		}
-		for (i = 0; i< MAX_WIN; i++) {
+		for (i = 0; i < MAX_WIN; i++) {
 			c->mem[i].name = p_dev->devname;
 			c->mem[i].flags = IORESOURCE_MEM;
 		}
@@ -651,7 +651,7 @@ static int pcmcia_card_add(struct pcmcia_socket *s)
 }
 
 
-static int pcmcia_requery_callback(struct device *dev, void * _data)
+static int pcmcia_requery_callback(struct device *dev, void *_data)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 	if (!p_dev->dev.driver) {
@@ -726,7 +726,7 @@ static void pcmcia_requery(struct pcmcia_socket *s)
  * the one provided by the card is broken. The firmware files reside in
  * /lib/firmware/ in userspace.
  */
-static int pcmcia_load_firmware(struct pcmcia_device *dev, char * filename)
+static int pcmcia_load_firmware(struct pcmcia_device *dev, char *filename)
 {
 	struct pcmcia_socket *s = dev->socket;
 	const struct firmware *fw;
@@ -778,7 +778,8 @@ static int pcmcia_load_firmware(struct pcmcia_device *dev, char * filename)
 
 #else /* !CONFIG_PCMCIA_LOAD_CIS */
 
-static inline int pcmcia_load_firmware(struct pcmcia_device *dev, char * filename)
+static inline int pcmcia_load_firmware(struct pcmcia_device *dev,
+				       char *filename)
 {
 	return -ENODEV;
 }
@@ -1190,7 +1191,7 @@ static int pcmcia_dev_resume(struct device *dev)
 }
 
 
-static int pcmcia_bus_suspend_callback(struct device *dev, void * _data)
+static int pcmcia_bus_suspend_callback(struct device *dev, void *_data)
 {
 	struct pcmcia_socket *skt = _data;
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
@@ -1201,7 +1202,7 @@ static int pcmcia_bus_suspend_callback(struct device *dev, void * _data)
 	return runtime_suspend(dev);
 }
 
-static int pcmcia_bus_resume_callback(struct device *dev, void * _data)
+static int pcmcia_bus_resume_callback(struct device *dev, void *_data)
 {
 	struct pcmcia_socket *skt = _data;
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
-- 
1.7.10.4

