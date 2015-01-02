Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbbABIET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 03:04:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21228 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbABIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 03:04:01 -0500
X-AuditID: cbfee68e-f79b46d000002b74-2e-54a650ed9510
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v2 RESEND 2/2] mfd: arizona: Update DT binding to
 support OUTn_MONO init_data
Date: Fri, 02 Jan 2015 17:03:49 +0900
Message-id: <1420185829-24886-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSqPs2YFmIwcVfFhZTHz5hs/g35Qa7
	xfwj51gt+t8sZLXY9fc+o8W5VysZLe5/PcpocXnXHDaLpdcvMlksf/ufzWLC9LUsFq17j7Bb
	nO5mdeD1WDNvDaPH5b5eJo+Vy7+weWxa1cnmcefaHjaPeScDPV5O/M3m0bdlFaPH501yAZxR
	XDYpqTmZZalF+nYJXBm9z6azFhzkrth6awlTA+Muzi5GTg4JAROJc3NeMUHYYhIX7q1n62Lk
	4hASWMooceRCJxtM0ffOu1CJRYwSn17PZIRw5jBJ3Hp+lRmkik1AQ+L7581gtoiAjsTnj8eY
	QYqYBfYwSUxasJodJCEskCMxo+ckI4jNIqAqsfhEB9huXgE3iRenlkGt05bY1zATzOYUcJd4
	uOIGK4gtBFTzf8MKVpChEgKP2CXWbF/NCjFIQOLb5EMsXYwcQAlZiU0HmCHmSEocXHGDZQKj
	8AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYgbF0+t+zvh2MNw9YH2IU4GBU4uFVuLY0
	RIg1say4MvcQoynQhonMUqLJ+cCIzSuJNzQ2M7IwNTE1NjK3NFMS502Q+hksJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgXHpnANW7GGBXQ+NNt0tdfpnbxF180Uea+VSZeX6idtn3Xk5VXtP
	6s2F757POfquKd5xyYdzy4/liv+1Tbt0SsL201LjnbPWZGRY6bYq9dwuvRHU+vO8numKhXcu
	vvGbUMen73rRcOm+g3neO743XT478XvKycpHW9Pc03du28+mcu1oxIqDrEUPlFiKMxINtZiL
	ihMBjmTsKqACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAd23ActCDF7+MLCY+vAJm8W/KTfY
	LeYfOcdq0f9mIavFrr/3GS3OvVrJaHH/61FGi8u75rBZLL1+kcli+dv/bBYTpq9lsWjde4Td
	4nQ3qwOvx5p5axg9Lvf1MnmsXP6FzWPTqk42jzvX9rB5zDsZ6PFy4m82j74tqxg9Pm+SC+CM
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY0ftsOmvBQe6KrbeWMDUw7uLs
	YuTkkBAwkfjeeZcNwhaTuHBvPZDNxSEksIhR4tPrmYwQzhwmiVvPrzKDVLEJaEh8/7wZzBYR
	0JH4/PEYM0gRs8AeJolJC1azgySEBXIkZvScZASxWQRUJRaf6GACsXkF3CRenFoGtU5bYl/D
	TDCbU8Bd4uGKG6wgthBQzf8NK1gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc
	qc+kdzCuarA4xCjAwajEw6twbWmIEGtiWXFl7iFGCQ5mJRHePrklIUK8KYmVValF+fFFpTmp
	xYcYTYGumsgsJZqcD0wieSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwc
	nFINjEunxuyuZHgZ/9L9jkk7o0Zw5ffOq2tNdt9j/fWl7kjK3q86B9t3lx47sjnldHDFbo7u
	M3+3qFvrMWsxrTh3+8an5oaMKadvL3b8P7eaNbno+taS7XcWLS0uLRMqXtz6Ztq0/8/de8uD
	q1m6Sw6d5P4t7cW8ROrz1ZSTpxVFe/bMfMm0e2OutJsSS3FGoqEWc1FxIgB9jrH66gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update DT binding to support OUTn_MONO init_data. Each
output signal can be configurated as a mono differential output.
The mono differential configuration is selected using the OUTn_MONO
registers.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 7bd1273..cf11d42 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -49,6 +49,13 @@ Optional properties:
     input singals. If values less than the number of input signals, elements
     that has not been specifed are set to 0 by default.
 
+  - wlf,out-mono : A list of OUTn_MONO register values, where n is the number
+    of output signals. Valid values are 0 (Disabled) and 1 (Enabled). If absent,
+    OUTn_MONO registers set to 0 by default. If present, values must be specified
+    less than or equal to the number of output signals. If values less than the
+    number of input signals, elements that has not been specified are set to 0
+    by default.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8

