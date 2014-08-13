Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaHMLzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:55:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28262 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMLy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:54:58 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-9f-53eb52108073
Date: Wed, 13 Aug 2014 20:54:56 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v2 2/2] mfd: arizona: Update DT binding to support
 INn_MODE init_data
Message-id: <20140813205456.636abc68@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsWyRsSkSFcg6HWwwYTzBhZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGVs3CZSMJ+74sWrduYGxumcXYyc
	HBICJhLbXu5jhrDFJC7cW8/WxcjFISSwlFFi+ooHrDBFT/ffY4VITGeU+PvqKBNIQkign0li
	wj+3LkYODhYBVYm9LWEgYTYBDYnvnzeDDRUBGnp7TiczSC+zwE8mieYVT8ASwgIpErM+HAKb
	wyvgKnFr6ndGiGU2Eqt3rmOGiAtK/Jh8jwXEZhbQkti8rYkVwpaX2LzmLdTVMzkkvv3SBrFZ
	BAQkvk0+xAJyj4SArMSmA1AlkhIHV9xgmcAoMgvJ1FlIps5CMnUBI/MqRtHUguSC4qT0IiO9
	4sTc4tK8dL3k/NxNjMBYPv3vWd8OxpsHrA8xJgOtnMgsJZqcD0wFeSXxhsZmRhamJqbGRuaW
	ZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcX7tBbXe9StPPYto/rPaJuNa
	vdQ5Xabwlc9+GDNv0mdkua114Tprt4Cz1vstsSLsVT/Vdz/Wm/zn5s2gk8pPM8q9p7ivDVxs
	sN7L/dLtxR4S/5KXbJ26+EJL0+0DnWeb7xWttsz+dc86VfL5nO6iLR4vejs0Z4lN2Gm3+Ont
	RPHKjMlK6luCWpVYijMSDbWYi4oTAUUQpDn7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQV2BoNfBBs9aNCyuXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOYsXGbSMF87ooXr9qZGxinc3YxcnJICJhIPN1/jxXCFpO4cG89WxcjF4eQwHRGib+vjjKB
	JIQE+pkkJvxz62Lk4GARUJXY2xIGEmYT0JD4/nkzM4gtAtR7e04nM0gvs8BPJonmFU/AEsIC
	KRKzPhwCm8Mr4Cpxa+p3RohlNhKrd65jhogLSvyYfI8FxGYW0JLYvK2JFcKWl9i85i3zBEa+
	WUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4FTxTHoH46oGi0OMAhyM
	Sjy8O1xfBQuxJpYVV+YeYpTgYFYS4T1s8zpYiDclsbIqtSg/vqg0J7X4EKMp0NcTmaVEk/OB
	aSyvJN7Q2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVANj18rJeqXHgzRS
	/HektfzNqizjPmS+MWdZ7FnRNW+CTu5PYjrN4Ls7uOqBVeZublblR+WXjNVyMjdt2BLt6cEX
	67f60AeFS/ukj+XdffQ/okklTz7CWH1x6IcfS9nMMr7uaL59Sfac/rfJ5v/+nN0gstSs6BXf
	szVdy0I7ZIS/cL5fGhMnWLZKiaU4I9FQi7moOBEAB830ECsDAAA=
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
 Documentation/devicetree/bindings/mfd/arizona.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 5c7e723..b8c131e 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,14 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - wlf,inmode : A list of INn_MODE register values, where n is the number
+    of input signal. Each input signal path can be configurated either as a
+    Analogue or Digital using the INn_MODE registers. If absent, INn_MODE
+    registers set to 0 by default. If present, values must be specified less
+    than or equal to the number of input singal. If values less than the
+    number of input signal, elements that has not been specifed are set to 0
+    by default.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8

