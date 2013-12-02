Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3LBXKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:10:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33309 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3LBXKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:10:31 -0500
X-AuditID: cbfee691-b7f666d0000048b0-6c-529d13667e2d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Jean Delvare'" <khali@linux-fr.org>,
        "'Guenter Roeck'" <linux@roeck-us.net>, lm-sensors@lm-sensors.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 10/39] hwmon: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:10:29 +0900
Message-id: <001f01ceefb3$b1968820$14c39860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAlFNg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zI9004blBBpu+8Fo0L17PZnF54SVW
	i8a/kRaXd81hs3iy8AyTxZ1pe9kc2DyuNJxk89g/dw27x4OJu9k8dn5vYPfo27KK0ePzJrkA
	tigum5TUnMyy1CJ9uwSujA2/djEWbJOuWLT8EGsD4zzxLkZODgkBE4nHkz6wQ9hiEhfurWfr
	YuTiEBJYxihxfsZOZpiiRc97mUBsIYFFjBIH3htDFP1ilDjd28gKkmATUJP48uUw2CQRAVOJ
	je+nMIIUMQusY5TYs+MzC0S3rcT0F5uBJnFwcArYSfR9qgUJCws4Sbx7CrGMRUBV4sKDGywg
	JbxA5U9PCIOEeQUEJX5Mvgc2hVlAS2L9zuNMELa8xOY1b5lByiUE1CUe/dWFuMBIYt39X6wQ
	JSIS+168A7tGQuAju8SrfRtYIFYJSHybfIgFoldWYtMBqHclJQ6uuMEygVFiFpLNs5BsnoVk
	8ywkKxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECInciTsY7x+wPsSYDLR+IrOUaHI+
	MPLzSuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx
	p+ki2Z26SjPNH0jZzbi/cvLyLsvomT2yu1QOfXsUe2vuh2wFnqIz+X0HfIz3HbxvUfF2F9MR
	dW6NSYGJl81SQ9ZFT/+8tNb51imO7bOPzNr6tW3W98ppdxmbF7x9YV358NnXv1k87zLDxeMY
	plgfPnpz4yqFg2e9ND9cfHSltPNqlG/u7Z6z85VYijMSDbWYi4oTAXx9fuHyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd004blBBr8ucVo0L17PZnF54SVW
	i8a/kRaXd81hs3iy8AyTxZ1pe9kc2DyuNJxk89g/dw27x4OJu9k8dn5vYPfo27KK0ePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkbfu1iLNgmXbFo+SHWBsZ5
	4l2MnBwSAiYSi573MkHYYhIX7q1nA7GFBBYxShx4b9zFyAVk/2KUON3byAqSYBNQk/jy5TA7
	iC0iYCqx8f0URpAiZoF1jBJ7dnxmgei2lZj+YjPQVA4OTgE7ib5PtSBhYQEniXdPdzKD2CwC
	qhIXHtxgASnhBSp/ekIYJMwrICjxY/I9sCnMAloS63ceZ4Kw5SU2r3nLDFIuIaAu8eivLsQF
	RhLr7v9ihSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJEZwWnkntYFzZYHGIUYCDUYmH98H2OUFCrIllxZW5hxglOJiVRHg7eeYGCfGmJFZW
	pRblxxeV5qQWH2JMBvpzIrOUaHI+MGXllcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEk
	NTs1tSC1CGYLEwenVAMjB3v1lX1HdoT9ChU5cZ3pyZcHH0rvTL9/+ILpB18+lcZfQX7npzjO
	etwbPPudY1/bf6sNii1/xXccjV/6adb9kmy/I6Hv7hnKlU85+/bguxKmmdtz1kttTzVoMJKb
	0269YtKR/hfC5ZfZRE1unudYEqDdbCJ75NKh3sKn17YflmK+sUPd5qV3sxJLcUaioRZzUXEi
	AKRiBD9PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/hwmon/fam15h_power.c |    2 +-
 drivers/hwmon/k10temp.c      |    2 +-
 drivers/hwmon/k8temp.c       |    2 +-
 drivers/hwmon/sis5595.c      |    2 +-
 drivers/hwmon/via686a.c      |    2 +-
 drivers/hwmon/vt8231.c       |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index dff8410..6040121 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -249,7 +249,7 @@ static void fam15h_power_remove(struct pci_dev *pdev)
 	sysfs_remove_group(&dev->kobj, &fam15h_power_attr_group);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) = {
+static const struct pci_device_id fam15h_power_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index d65f3fd..e375e9f 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -204,7 +204,7 @@ static void k10temp_remove(struct pci_dev *pdev)
 			   &sensor_dev_attr_temp1_crit_hyst.dev_attr);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(k10temp_id_table) = {
+static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 5b50e9e..734d55d 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -135,7 +135,7 @@ static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp, NULL, 1, 0);
 static SENSOR_DEVICE_ATTR_2(temp4_input, S_IRUGO, show_temp, NULL, 1, 1);
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
-static DEFINE_PCI_DEVICE_TABLE(k8temp_ids) = {
+static const struct pci_device_id k8temp_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ 0 },
 };
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 1404e63..05565d2d 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -752,7 +752,7 @@ static struct sis5595_data *sis5595_update_device(struct device *dev)
 	return data;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(sis5595_pci_ids) = {
+static const struct pci_device_id sis5595_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
 	{ 0, }
 };
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index c9dcce8..babd732 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -824,7 +824,7 @@ static struct via686a_data *via686a_update_device(struct device *dev)
 	return data;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(via686a_pci_ids) = {
+static const struct pci_device_id via686a_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686_4) },
 	{ }
 };
diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index 0e70178..48025b7 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -766,7 +766,7 @@ static struct platform_driver vt8231_driver = {
 	.remove	= vt8231_remove,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(vt8231_pci_ids) = {
+static const struct pci_device_id vt8231_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8231_4) },
 	{ 0, }
 };
-- 
1.7.10.4


