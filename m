Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaICC7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:59:46 -0400
Received: from plane.gmane.org ([80.91.229.3]:44298 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbaICC7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:59:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: [PATCH] pci/pci-driver: Set pci interface in uppercase
Date: Tue, 2 Sep 2014 19:46:31 -0700
Organization: L2N
Message-ID: <20140902194631.60b1a4db@127>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/zjqRaYwnI4XX.GsEv.RlFww"
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip70-185-178-95.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/zjqRaYwnI4XX.GsEv.RlFww
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems to me this needs to go along with previous patch from

http://marc.info/?l=linux-kernel&m=140914429629912&w=2

Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
Date: Wed, 27 Aug 2014 14:57:57 +0200


Signed-off-by: Richard Hubbell <richard_hubbe11@lavabit.com>



--MP_/zjqRaYwnI4XX.GsEv.RlFww
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pci-drive.c.patch

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d04c5ad..1fce3b7 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1392,7 +1392,7 @@ static int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (add_uevent_var(env, "PCI_SLOT_NAME=%s", pci_name(pdev)))
 		return -ENOMEM;
 
-	if (add_uevent_var(env, "MODALIAS=pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x",
+	if (add_uevent_var(env, "MODALIAS=pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X",
 			   pdev->vendor, pdev->device,
 			   pdev->subsystem_vendor, pdev->subsystem_device,
 			   (u8)(pdev->class >> 16), (u8)(pdev->class >> 8),

--MP_/zjqRaYwnI4XX.GsEv.RlFww--


