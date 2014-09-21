Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaIUDA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 23:00:57 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43323 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaIUDAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 23:00:38 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        zonque@gmail.com, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH 3/3] dt: cap1106 active-high property addition
Date: Sat, 20 Sep 2014 20:01:09 -0700
Message-Id: <1411268469-21283-4-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documenting the microchip,active-high property for interrupt pin
behavior.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 Documentation/devicetree/bindings/input/cap1106.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/cap1106.txt b/Documentation/devicetree/bindings/input/cap1106.txt
index 4b46390..7e64fd6 100644
--- a/Documentation/devicetree/bindings/input/cap1106.txt
+++ b/Documentation/devicetree/bindings/input/cap1106.txt
@@ -26,6 +26,10 @@ Optional properties:
 				Valid values are 1, 2, 4, and 8.
 				By default, a gain of 1 is set.
 
+	microchip,active-high:	By default the interrupt pin  is active low open
+				drain. This property allows using the active high
+				push-pull output.
+
 	linux,keycodes:		Specifies an array of numeric keycode values to
 				be used for the channels. If this property is
 				omitted, KEY_A, KEY_B, etc are used as
-- 
1.9.1

