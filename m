Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbaCQMoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:44:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbaCQMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:43:57 -0400
X-AuditID: cbfee68e-b7f566d000002344-e8-5326ee0be0bd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 3/4] Documentation: dt: charger-manager: Change the way to
 get fuel-gauge power-supply device
Date: Mon, 17 Mar 2014 21:43:46 +0900
Message-id: <1395060227-23378-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWyRsSkSJfnnVqwwecljBbXvzxntZj05D2z
	xcSVk5ktzja9Ybe4vGsOm8XtxhVsDmweO2fdZffYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDL2tr5iKrjFU7Hk4naWBsYDXF2MnBwSAiYSW7vPMEHYYhIX7q1n62Lk4hASWMooMXXb
	XTaYor7u9awQiemMEiseL2GHcBqZJNat3cIKUsUmoCWx/8UNsA4RAV2Jmz2X2UFsZoFaiX3X
	msBqhAWKJQ79aASLswioSkz/eh1oNQcHr4CrxLUdBRDL5CQ+7HkEVsIp4CZxeec0ZhBbCKhk
	9dPFYHslBNrZJbbt7meCmCMg8W3yIRaQORICshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5IL
	ipPSi4z0ihNzi0vz0vWS83M3MQID+vS/Z307GG8esD7EmAw0biKzlGhyPjAi8kriDY3NjCxM
	TUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY91qkW1rxeQfNP/N
	M6k947jGIq2qSH4l23LzE//Z+O5pvlCXZvvC+ygy9cbmre3THvYymMjk3csPYMp3qdod0/qn
	NN1S8sxvR6fj83ym+URUnH3Lfeh18cqeqS+Ov1LftWff7XfHVj45u+7Zzm9BP5m/Jcsws2wI
	n62zcP+FogD1S9ovw8+9PaHEUpyRaKjFXFScCAAj6ht1fgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQV3ud2rBBhPOmltc//Kc1WLSk/fM
	FhNXTma2ONv0ht3i8q45bBa3G1ewObB57Jx1l91j8wotj74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2Nv6iqngFk/FkovbWRoYD3B1MXJySAiYSPR1
	r2eFsMUkLtxbz9bFyMUhJDCdUWLF4yXsEE4jk8S6tVvAqtgEtCT2v7jBBmKLCOhK3Oy5zA5i
	MwvUSuy71gRWIyxQLHHoRyNYnEVAVWL61+tMXYwcHLwCrhLXdhRALJOT+LDnEVgJp4CbxOWd
	05hBbCGgktVPF7NPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Xp5J72Bc1WBx
	iFGAg1GJh3eCslqwEGtiWXFl7iFGCQ5mJRFerbdAId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYS
	Tc4HxnJeSbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAqdiy/
	uHFq4iXGWbNED1wx/p5suG+xsShLZo15vWWtt3v6bn2TCiFOQcO3PH2nP/fvucDoHxVmdU3k
	NcMPl/WOvQnJ0geXd9zo/nJOKfPRDKf6VYK2JecyzLl+/YjY5BKcUdJzsiPh1rGadME7EkxP
	+0/++2+d5MtdvztP0IZts/SqGewGvkosxRmJhlrMRcWJANNB1h3bAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use the phandle of fuel-gauge device instead of the name of fuel-gauge
device to get fuel-gauge device directly from dt.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 .../devicetree/bindings/power_supply/charger-manager.txt          | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/power_supply/charger-manager.txt b/Documentation/devicetree/bindings/power_supply/charger-manager.txt
index 2b33750..ceebd66 100644
--- a/Documentation/devicetree/bindings/power_supply/charger-manager.txt
+++ b/Documentation/devicetree/bindings/power_supply/charger-manager.txt
@@ -6,7 +6,7 @@ Required properties :
  - <>-supply : for regulator consumer
  - cm-num-chargers : number of chargers
  - cm-chargers : name of chargers
- - cm-fuel-gauge : name of battery fuel gauge
+ - fuelgauge : phandle of fuelgauge power-supply device
  - subnode <regulator> :
 	- cm-regulator-name : name of charger regulator
 	- subnode <cable> :
@@ -30,6 +30,10 @@ Optional properties :
  - cm-dis/charging-max = limits of charging duration
 
 Example :
+	fuelgauge0: max17047@36 {
+		compatible = "maxim,max17047";
+	};
+
 	charger-manager@0 {
 		compatible = "charger-manager";
 		chg-reg-supply = <&charger_regulator>;
@@ -48,7 +52,7 @@ Example :
 		cm-num-chargers = <3>;
 		cm-chargers = "charger0", "charger1", "charger2";
 
-		cm-fuel-gauge = "fuelgauge0";
+		fuelgauge = <&fuelgauge0>;
 
 		cm-thermal-zone = "thermal_zone.1"
 		/* in deci centigrade */
-- 
1.8.0

