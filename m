Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaDNLra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:47:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29769 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaDNLrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:47:24 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-d5-534bcacbbc9e
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 02/13] Documentation: update charger-manager devicetree
 bindings
Date: Mon, 14 Apr 2014 13:46:13 +0200
Message-id: <1397475984-28001-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRW0hTcRwHcP87l51NB6dpdlhpteghMW1l9AetDNQOCFlIL73k0uMltzk2
	FQ3KpVmazk1LzDkvM2/TqWSznJT3p+a1oQZqWs1S00IzlLJsU3r7/L6/L/wefgTCt6ACIkGW
	zChkYokQ56LWv5/I49Y34ZEn8uo8oGkhGPa2H4O9sxlwcv0LBovs3xFYOTCMwULjIwRqlg0Y
	1JhDYM9WB4BZT1txOLxkBDB3yI7A0fl8HNZ2NaHQcL8GhbZOPQ7LajQorK7LRqDdMMiCzQMz
	bFg7OcaCU3cbcFi/so1DbUkzCuf6LWzYsliCwuzXA2zYNbqFwdYnX9Fgb9pUYQK0rUDNojst
	eozWatYAbdHNsGlj/TpO9/80oPTzBh+6rTEXp5eaSjF6euIVTneXm9i0OusbTi8W/sZpy4aK
	TReYG8Fl92vcoBhGkpDKKPzPRXHj35mHMPm8a9qYLRtTgXbOQ8AhKDKAss3W4bv2pEbftzrM
	JfhkNaBq3o6gu8MDFvWxNhN1tnDSlzJvaIHTHiRCVRWP7Bgh5zHq5eZZp93Jq1SJVYc4jZJH
	qb7MvJ0OjwylFjpzHSYc1w5R+qIgZ8whw6je0j87db6j0pM1hWgBrwq4NIK9jDxarrwRJxX5
	KcVSZYoszi86SdoGdh76WdABjCrYB0gCCN14OfrwSD4mTlWmS/sARSBCD15ouyPixYjTbzGK
	pOuKFAmj7AP7CVS4j9eTHXiFT8aJk5lEhpEziv9bFsERqECgYdlO6NgHBlcKTeN5ES8CJsJE
	3OlnU2l2W7rnqT2VR0IPs88URXnI1OXLaW1pkoxVtwvjp8t6LmFe1cWx2z9yNs+HtOZXGEq6
	fHWc1YvBazc3JcOrOYomb/7ktutIAu+XSDCR8niOG2tqifA3clyst7261WTihxj04D385B0h
	qowXi3wQhVL8D3zZovHMAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes charger-manager bindings to be compatible with
new extcon bindings.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 .../bindings/power_supply/charger-manager.txt      |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/power_supply/charger-manager.txt b/Documentation/devicetree/bindings/power_supply/charger-manager.txt
index 2b33750..f987bb5 100644
--- a/Documentation/devicetree/bindings/power_supply/charger-manager.txt
+++ b/Documentation/devicetree/bindings/power_supply/charger-manager.txt
@@ -10,8 +10,7 @@ Required properties :
  - subnode <regulator> :
 	- cm-regulator-name : name of charger regulator
 	- subnode <cable> :
-		- cm-cable-name : name of charger cable
-		- cm-cable-extcon : name of extcon dev
+		- extcon-cable : specified extcon cable
 (optional)	- cm-cable-min : minimum current of cable
 (optional)	- cm-cable-max : maximum current of cable
 
@@ -65,14 +64,14 @@ Example :
 		regulator@0 {
 			cm-regulator-name = "chg-reg";
 			cable@0 {
-				cm-cable-name = "USB";
-				cm-cable-extcon = "extcon-dev.0";
+				/* USB cable */
+				extcon-cable = <&extcon 0>;
 				cm-cable-min = <475000>;
 				cm-cable-max = <500000>;
 			};
 			cable@1 {
-				cm-cable-name = "TA";
-				cm-cable-extcon = "extcon-dev.0";
+				/* TA cable */
+				extcon-cable = <&extcon 1>;
 				cm-cable-min = <650000>;
 				cm-cable-max = <675000>;
 			};
-- 
1.7.9.5

