Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128AbaDJNSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:18:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161042AbaDJNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:17:52 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-15-534699f4fc94
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 02/13] Documentation: update charger-manager devicetree bindings
Date: Thu, 10 Apr 2014 15:16:40 +0200
Message-id: <1397135811-12866-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTcRjG++9cdrRWh7X0pAmxiErKLIT+oahBjlOfVhaRX2rq8UJOx+Yk
	V+HSlijapjZFnff7nPeJTpq3CWmmzlYqaTealpaGovlBsdyib7/neX68X14C4bahHkRsfCIj
	jRfF8XFXdHTnK3lmvVAQ6ju3cBgavgfDgc5TcOBTCpxe/4bBXPsvBJYNjWMwpyEPgeqfFRhU
	Gy/D/u1uANOqWnA4vtQAYMaYHYHW+Swc1vQ2orDiaTUKbT06HBZXq1FYWatCoL3iNQvWTE+y
	4OzjehzWLf/BoaagCYWfLSY2bF4sQKHKPMSGvdZtDPa9vRrsRRtKDYD+vZGL0rZn2Sy6x6TD
	aI16DdCmog9suqFuHactGxUo3VHvTbfrM3B6qbEQo+emXuB0X4mBTWenreD0Ys4WTps2lWwh
	L8w1IJKJi01ipGcD77rGzBjHMMn83vuTNhWmBJ0umcCFoEg/qmt0g/2P3SjrxxY8E7gSXLIS
	UM3mUvAvpLOo/OwS4LBw8jRl3NQ4mUciVLl2wikh5AhG6Qf6EMdwkBRSDT0Tu2cJAiWPU8XD
	1x01hwyh0lNVzpoij1K63AAHupACymw75kDurqFt4msApxzs0YNDjCRCIguPFp/3kYnEMnl8
	tE9EgrgdOB+54NkN9Eo4CEgC8Pdx+mtDQrmYKEmWLB4EFIHweZw2rSCUy4kUJSsYacIdqTyO
	kQ0CTwLlu3MGVP7XuGS0KJG5xzASRvp/ZREuHkrQ6jurNRvXVgJWLfgD4ZdlaxfrUtGMYsRP
	/u5J6hW23ZqmrnoYFjV8JC/fYpp5JdC15mxb07MUQT8o3kjfTv3sTYGiQPwejz1w8sIq8px7
	Y7HrzUWvre6VltaOwFvGKX9zVODtAEP5o9aUE9ygVCFZJi98CSVu7vubLebKxnA+KosRnfNG
	pDLRXxkPuNfEAgAA
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

