Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaEFRKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:10:44 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50944 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaEFRKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:10:42 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 1/2] of: add mundoreader and radxa vendor prefixes
Date: Tue,  6 May 2014 19:10:10 +0200
Message-Id: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new vendor prefixes for:

    * Mundo Reader S.L., a company that produces tablets and e-readers
    * Radxa, manufacturer of ARM boards

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---

v2:
 - use mundoreader prefix instead of bq as suggested by Heiko Stuebner

 Documentation/devicetree/bindings/vendor-prefixes.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index abc3080..53bd92f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -79,6 +79,7 @@ microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 moxa	Moxa
 mpl	MPL AG
+mundoreader	Mundo Reader S.L.
 mxicy	Macronix International Co., Ltd.
 national	National Semiconductor
 neonode		Neonode Inc.
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

