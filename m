Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaHSLOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:14:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41820 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaHSLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:14:09 -0400
X-AuditID: cbfee691-b7f306d000003d81-d4-53f3317f7f3a
Date: Tue, 19 Aug 2014 20:14:07 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v4 2/2] mfd: arizona: Update DT binding to support
 INn_MODE init_data
Message-id: <20140819201407.3447715e@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkRLfe8HOwwcMpchZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGUsPHiAuaCBu+LhxVksDYytnF2M
	nBwSAiYSs+YuZYKwxSQu3FvP1sXIxSEksJRRonXyV1aYojUvGlggEtMZJS5vf8sI4fQzSfw8
	t4YFpIpFQFWiaVIfI4jNJqAh8f3zZmYQWwRo7O05ncwgDcwCP5kkmlc8AUsIC6RIdM18C9bA
	K+Aq8aZ/FyPEOhuJ1TvXMUPEBSV+TL4HtoBZQEti87YmVghbXmLzmrdgQyUEpnJI7D7QCXWF
	gMS3yYeAbA6ghKzEpgPMEDMlJQ6uuMEygVFkFpKxs5CMnYVk7AJG5lWMoqkFyQXFSelFpnrF
	ibnFpXnpesn5uZsYgTF9+t+ziTsY7x+wPsSYDLRyIrOUaHI+MCXklcQbGpsZWZiamBobmVua
	kSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjkUP+PybvMQl2O89gncr/dt6f
	pcpKKso17RHa/n7fcote/3njIxxcn/+YY9tFCcmEc984zD49/L/s7TvRsp+7N3Qcfv2E8xh3
	RMQ0c5ffGzunTl/e1fl1+cO++lxWkXrns9O/2N8WmD/n6iaJ1rq1s1+ZaZ/Jv/ht8ekZsqGX
	djJ3Gldf1fs3V4mlOCPRUIu5qDgRAPz5eSX/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd16w8/BBvPWi1lcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktTj3aiWjxf2vRxktvl3pYLK4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	mHcy0OPlxN9sHn1bVjF6fN4kF8Ad1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sIYxY+HBA8wFDdwVDy/OYmlgbOXsYuTkkBAwkVjzooEFwhaTuHBvPVsXIxeHkMB0RonL298y
	Qjj9TBI/z60Bq2IRUJVomtTHCGKzCWhIfP+8mRnEFgHqvj2nkxmkgVngJ5NE84onYAlhgRSJ
	rplvwRp4BVwl3vTvYoRYZyOxeuc6Zoi4oMSPyffAFjALaEls3tbECmHLS2xe85Z5AiPfLCRl
	s5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMJ4JrWDcWWDxSFGAQ5GJR5e
	hS8fg4VYE8uKK3MPMUpwMCuJ8HZIfw4W4k1JrKxKLcqPLyrNSS0+xGgK9PZEZinR5HxgMssr
	iTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cC4763jpdOCKQv8J36S
	/9B/w/yks9KNM7n1q9JYFrR3RO59qud6/2qONC/PlVlRhz98iDRUF02u7F+auzUqheXnldZ+
	9+8sRl2bWNikg7983Ti5veD9V4GwI688t9ler6tbuPeVZQTjo2/Jj3hdwyRX6j2dzG/TcjJi
	kdy5TZqZmUFnbe+KSu9SYinOSDTUYi4qTgQAEI8dyi4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update DT binding to support INn_MODE init_data. Each
input signal path can be configurated either as a Analogue or
Digital using the INn_MODE registers.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 5c7e723..7bd1273 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,13 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - wlf,inmode : A list of INn_MODE register values, where n is the number
+    of input signals. Valid values are 0 (Differential), 1 (Single-ended) and
+    2 (Digital Microphone). If absent, INn_MODE registers set to 0 by default.
+    If present, values must be specified less than or equal to the number of
+    input singals. If values less than the number of input signals, elements
+    that has not been specifed are set to 0 by default.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8
