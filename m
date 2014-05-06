Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaEFV3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:29:47 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43942 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEFV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:29:45 -0400
Message-ID: <53695443.6020004@gmail.com>
Date: Tue, 06 May 2014 23:29:39 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org,
        kernel@lists.fedoraproject.org, andreas.utterberg@thundera.se,
        jwboyer@fedoraproject.org, sgruszka@redhat.com
Subject: Re: [PATCH] asus-nb-wmi: set wapf=4 for ASUSTeK COMPUTER INC. X75VBP
 & X550CA
References: <1398550344-3785-1-git-send-email-pomidorabelisima@gmail.com> <53684CF9.8020305@gmail.com> <5368F58C.1040702@gmail.com> <20140506144800.GA29600@srcf.ucam.org> <5369434A.1020909@gmail.com> <20140506205525.GA30712@srcf.ucam.org>
In-Reply-To: <20140506205525.GA30712@srcf.ucam.org>
Content-Type: multipart/mixed;
 boundary="------------060305080703050104050408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060305080703050104050408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit




--------------060305080703050104050408
Content-Type: text/x-patch;
 name="0001-WAPF-4-for-ASUSTeK-COMPUTER-INC.-X75VBP-WLAN-ON.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-WAPF-4-for-ASUSTeK-COMPUTER-INC.-X75VBP-WLAN-ON.patch"

>From d39d3460f1ab36365a48b6815dd9a5d26613d3ec Mon Sep 17 00:00:00 2001
From: poma <pomidorabelisima@gmail.com>
Date: Tue, 6 May 2014 22:03:38 +0200
Subject: [PATCH] WAPF 4 for ASUSTeK COMPUTER INC. X75VBP WLAN ON.

The 'asus-nb-wmi' WAPF parameter must be set to 4, so the internal Wireless LAN device is operational.

Signed-off-by: poma <pomidorabelisima@gmail.com>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 563f59e..674793d 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -182,6 +182,15 @@ static struct dmi_system_id asus_quirks[] = {
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X75VBP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X75VBP"),
+		},
+		.driver_data = &quirk_asus_x401u,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. 1015E",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
1.9.0



--------------060305080703050104050408--
