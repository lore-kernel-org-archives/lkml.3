Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaH3C13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 22:27:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30226 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaH3C1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 22:27:25 -0400
X-AuditID: cbfee68e-f79536d000000fd1-5b-5401368bf412
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v5 2/2] mfd: arizona: Update DT binding to support
 INn_MODE init_data
Date: Sat, 30 Aug 2014 11:27:19 +0900
Message-id: <1409365639-5320-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
References: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWyRsSkSLfbjDHEYPd2IYsrFw8xWUx9+ITN
	4t+UG+wW1788Z7WYf+Qcq0X/m4WsFrv+3me0OPdqJaPF/a9HGS0u75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHyuVf2Dw2repk87hzbQ+bx7yTgR4v
	J/5m8+jbsorR4/MmuQCuKC6blNSczLLUIn27BK6MJXuaGQuOclfsvrOFqYHxMGcXIyeHhICJ
	xKQrF9kgbDGJC/fWA9lcHEICSxklTu+cwQRTtHjCGRaIxHRGiXe9u5ggnDlMEjtmHGAEqWIT
	0JD4/nkzM4gtAjTq9pxOZpAiZoEOZokp23aBFQkLpEj0XN7ODmKzCKhK/Li7ihXE5hVwlbg0
	5zgrxDptiX0NM8Fu4hRwk7i/fiFYrxBQze2de9hBhkoI/GSXaHpxnxVikIDEt8mHgO7jAErI
	Smw6wAwxR1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECIy00/+e9e1g
	vHnA+hCjAAejEg/vhZcMIUKsiWXFlbmHGE2BNkxklhJNzgfGc15JvKGxmZGFqYmpsZG5pZmS
	OG+C1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzzC2x+xth5Tpz3inHn7GZx5d16QSI3
	p8bLKe74Yy2x2bK9cyXvo8Tzh9les1lZPJgxq9F154HLKWeZNiyvb56W2bup1Xl38FXGfrff
	gprp/xY/P/WFW+K075f3a7ZLTs3hDv49T+y8jdQjq+IPwbe0NMOa259y/L5UUto/o/1ExWrZ
	BcfXG95WYinOSDTUYi4qTgQAV4YM+68CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd1uM8YQg9WruSyuXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWuz6e5/R4tyrlYwW978eZbS4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweK5d/YfPYtKqTzePOtT1sHvNOBnq8
	nPibzaNvyypGj8+b5AK4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOA3lBSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZizZ
	08xYcJS7YvedLUwNjIc5uxg5OSQETCQWTzjDAmGLSVy4t56ti5GLQ0hgOqPEu95dTBDOHCaJ
	HTMOMIJUsQloSHz/vJkZxBYB6rg9p5MZpIhZoINZYsq2XWBFwgIpEj2Xt7OD2CwCqhI/7q5i
	BbF5BVwlLs05zgqxTltiX8NMNhCbU8BN4v76hWC9QkA1t3fuYZ/AyLuAkWEVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnAcP5PawbiyweIQowAHoxIP74WXDCFCrIllxZW5hxglOJiVRHil
	HgOFeFMSK6tSi/Lji0pzUosPMZoCXTWRWUo0OR+YYvJK4g2NTcyMLI3MDS2MjM2VxHkPtFoH
	CgmkJ5akZqemFqQWwfQxcXBKNTDOZl2wssLzY6ZUverbnaYNZ0R2RGy5+r2c8c9TvqQ4P1/W
	fY8mpS/v7lu6Ru1Uq0HG7E+77nJqZ+xxF3tl9OLYjcNGQWquz6y7EnMv3+EW0+Gdrmo8SYnV
	PvfbwoBJDbLupVFb3j9sNd917PlR6en6NmY7p0jY//LLieR7feqssmud1u7dHIlKLMUZiYZa
	zEXFiQAjZ2Zy+QIAAA==
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
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
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

