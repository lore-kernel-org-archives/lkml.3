Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbbAPQsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:48:42 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:62716 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbbAPQsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:48:41 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: swarren@wwwdotorg.org, lee@kernel.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 2/4] dt-bindings: Add root properties for Raspberry Pi B and B+
Date: Fri, 16 Jan 2015 16:48:15 +0000
Message-Id: <1421426897-27225-3-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
References: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K0:ejwF4PaJgblWHqJFUfwvoo9EXEfueQ/9j25k854z5HHm+ex6/EW
 yn4mBSaiZXfe/3kiZvFL91VSr+T+el6AsBKIuxP+JI4wOwOP0etIufO/RoJ+HdRUTWP5W70
 s4Bg60KamqzALKHRLuA21CgawbbOV4X16EZZVwwOo/omoKkr9CiKpzMkkbiSqePAZ2+Fly9
 fanq5xYUmjTuM823QwOGQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds root compatible properties for the following boards:
- Raspberry Pi Model B
- Raspberry Pi Model B+

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 Documentation/devicetree/bindings/arm/bcm2835.txt |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/bcm2835.txt b/Documentation/devicetree/bindings/arm/bcm2835.txt
index ac68348..789aca2 100644
--- a/Documentation/devicetree/bindings/arm/bcm2835.txt
+++ b/Documentation/devicetree/bindings/arm/bcm2835.txt
@@ -1,8 +1,14 @@
 Broadcom BCM2835 device tree bindings
 -------------------------------------------
 
-Boards with the BCM2835 SoC shall have the following properties:
+Raspberry Pi Model B
+Required root node properties:
+compatible = "raspberrypi,model-b", "brcm,bcm2835";
 
-Required root node property:
+Raspberry Pi Model B+
+Required root node properties:
+compatible = "raspberrypi,model-b-plus", "brcm,bcm2835";
 
+Generic BCM2835 board
+Required root node properties:
 compatible = "brcm,bcm2835";
-- 
1.7.9.5

