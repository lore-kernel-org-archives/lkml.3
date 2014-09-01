Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaIALPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:15:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59826 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaIALOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:14:45 -0400
X-AuditID: cbfee68e-f79536d000000fd1-e9-540455221ec9
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 3/3] mfd: max77693: add haptic of_compatible in mfd_cell
Date: Mon, 01 Sep 2014 20:14:31 +0900
Message-id: <1409570071-26719-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkUFcplCXE4PYKbovrX56zWhxe9ILR
	YkfDEVaL+1+PMlrc/PSN1eLyrjlsFqe7WR3YPXbOusvucefaHjaPeScDPfq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugStjzvOdrAW3BCrapt5lb2A8wtvFyMkhIWAicePzXTYIW0ziwr31QDYX
	h5DAUkaJpe/bWWGKXl68xgKRmM4ocfb6DmYIp41JYuWjuewgVWwC2hLf1y8G6xARqJTo737B
	ClLELNDDKPG9fTUzSEJYwEPizNcXLCA2i4CqxNSuTWBxXqD42Tt/gHZzAK1TkJgzyQYkzCng
	KbH72VmwmUJAJatWfmIEmSkhMJ1d4uXiL2wQcwQkvk0+xALRKyux6QAzxNWSEgdX3GCZwCi8
	gJFhFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZgkJ/+96xvB+PNA9aHGAU4GJV4eB/MYg4R
	Yk0sK67MPcRoCrRhIrOUaHI+MJbySuINjc2MLExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgnH6o+VvsglemN8/0Wbc2TAnnvNBkmqVgYmvpXinXmOyou4qB/+us
	8OfS8lvCs2eYixwUu+7A/FZoZtatu2+mnpnl5/jk2peq7oT8NP0y+Z+X38lpnOC9t/tH+b4z
	E5oPKqxtPat3YvJOn2szt+xarsCeuEtNtJ5dPEG+NX/XxSPfTNSDWeSblViKMxINtZiLihMB
	/uyJiW0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jQV2lUJYQg80fmS2uf3nOanF40QtG
	ix0NR1gt7n89ymhx89M3VovLu+awWZzuZnVg99g56y67x51re9g85p0M9OjbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGXOe72QtuCVQ0Tb1LnsD4xHe
	LkZODgkBE4mXF6+xQNhiEhfurWfrYuTiEBKYzihx9voOZginjUli5aO57CBVbALaEt/XL2YF
	sUUEKiX6u1+wghQxC/QwSnxvX80MkhAW8JA48/UF2FgWAVWJqV2bwOK8QPGzd/4AreAAWqcg
	MWeSDUiYU8BTYvezs2AzhYBKVq38xDiBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOAYeia9g3FVg8UhRgEORiUe3gezmEOEWBPLiitzDzFKcDArifAWOrKECPGmJFZWpRblxxeV
	5qQWH2I0BTpqIrOUaHI+ML7zSuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0
	MXFwSjUwlnfkzvD5pnVeZqXB4skqNzWNP1x0OhhwalVVx6yHUTN4dRa/djlnbByz5vPH1elv
	Gr04HbsTMxnK+iLN5Ta53GpvkKs8dVzC6bua47UFT3knznj+4OShSs/ra5ruv14QWvpy5pI7
	Gsy29mqGW1ZG8OZ2lflN4S9ReGVzq06Gb+XCihvH23g4lFiKMxINtZiLihMBh2/MmLcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic of_compatible in order to use the Haptic device driver
using devicetree. and added the related documentation and example.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   19 +++++++++++++++++++
 drivers/mfd/max77693.c                             |    2 +-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..6e30ad8 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,18 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+- haptic :
+ Required properties:
+	- compatible : Must be "maxim,max77693-hpatic"
+	- pwms : phandle to the physical PWM device,
+		A feel can be changed by changing a peroid cycle.
+ Optional properties:
+	 - haptic-supply : power supply for haptic motor
+	 - pwm-names : Name to be used by the PWM subsystem for the PWM device
+
+ The haptic require of max77693 have to be instantiated under subnod
+  named "haptic" using the following haptic format in example.
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +64,11 @@ Example:
 					regulator-boot-on;
 			};
 		};
+
+		haptic {
+			compatible = "maxim,max77693-haptic";
+			haptic-supply = <&haptic_supply>;
+			pwms = <&pwm 0 38022 0>;
+			pwm-names = "haptic";
+		};
 	};
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index fbfed56..ceb7ebf 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -46,7 +46,7 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
-	{ .name = "max77693-haptic", },
+	{ .name = "max77693-haptic", .of_compatible = "maxim,max77693-haptic" },
 };
 
 static const struct regmap_config max77693_regmap_config = {
-- 
1.7.9.5

