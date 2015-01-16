Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbbAPQtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:49:07 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57890 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbbAPQtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:49:03 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: swarren@wwwdotorg.org, lee@kernel.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 1/4] dt-bindings: Add vendor prefix for Raspberry Pi
Date: Fri, 16 Jan 2015 16:48:14 +0000
Message-Id: <1421426897-27225-2-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
References: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K0:KHJmiAzQb6NkwZb2zUNWxa3ZFcDS8XQFnZHTfJm9slzv5Y7riYn
 ii4fuqwNB/FlLVECIGLfl5RBWz/+wkySJ7mlD6E2cDV5rGZdS6BCWVdlYOKmaQriTlZTWXo
 Z3wNRMQprEKckbvUioPay6iykLGiPnABzZaqDR+OLtt/qZvPer9p9S7SyDN61rYHnaaE7QZ
 M6Qhk2mCeR/ccZWbodI6Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the prefix is already in use, we need to add it in the
vendor list.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 5d2251a..0546f73 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -136,6 +136,7 @@ radxa	Radxa
 raidsonic	RaidSonic Technology GmbH
 ralink	Mediatek/Ralink Technology Corp.
 ramtron	Ramtron International
+raspberrypi	Raspberry Pi Foundation
 realtek Realtek Semiconductor Corp.
 renesas	Renesas Electronics Corporation
 ricoh	Ricoh Co. Ltd.
-- 
1.7.9.5

