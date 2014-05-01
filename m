Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaEATu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:50:57 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49618 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaEATuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:50:55 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Heiko Stuebner <heiko@sntech.de>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 1/2] of: add bq and radxa vendor prefixes
Date: Thu,  1 May 2014 21:50:34 +0200
Message-Id: <1398973835-26303-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new vendor prefixes for:

    * bq, a company that sells multimedia devices and 3D printers
    * Radxa, manufacturer of ARM boards

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index abc3080..6f8177c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -21,6 +21,7 @@ atmel	Atmel Corporation
 auo	AU Optronics Corporation
 avago	Avago Technologies
 bosch	Bosch Sensortec GmbH
+bq	bq
 brcm	Broadcom Corporation
 buffalo	Buffalo, Inc.
 calxeda	Calxeda
@@ -98,6 +99,7 @@ powervr	PowerVR (deprecated, use img)
 qca	Qualcomm Atheros, Inc.
 qcom	Qualcomm Technologies, Inc
 qnap	QNAP Systems, Inc.
+radxa	Radxa
 raidsonic	RaidSonic Technology GmbH
 ralink	Mediatek/Ralink Technology Corp.
 ramtron	Ramtron International
-- 
1.7.10.4

