Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaJEJAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:00:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58428 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaJEJAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:12 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 04/11] pt3: add comment
Date: Sun,  5 Oct 2014 17:59:40 +0900
Message-Id: <91a283b71e82584c290d3c2f1715b07d630edcff.1412497399.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PT3 needs frontend & tuners to run properly

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/pci/pt3/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
index 16c208a..f7b7210 100644
--- a/drivers/media/pci/pt3/Kconfig
+++ b/drivers/media/pci/pt3/Kconfig
@@ -6,5 +6,5 @@ config DVB_PT3
 	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for Earthsoft PT3 PCIe cards.
-
+	  You need to enable frontend (TC90522) & tuners (QM1D1C0042, MXL301RF)
 	  Say Y or M if you own such a device and want to use it.
-- 
1.8.4.5

