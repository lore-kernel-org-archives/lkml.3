Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3IIFdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:33:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3IIFde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:33:34 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-6a-522d5dac14b3
From: Jingoo Han <jg1.han@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] extcon: Remove casting the return value which is a void pointer
Date: Mon, 09 Sep 2013 14:33:32 +0900
Message-id: <005201cead1e$1f2007a0$5d6016e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tHhuTYM34YJZxQxqyBHj6tkE3WQ==
Content-language: ko
x-cr-hashedpuzzle: GcwL IJCH Ilz7 Jd73 Roap SdUa T40C Ug9o Vuql WcMt YK6e Y2X9
 aTl5 jNep lHRP
 m8Jd;4;YwB3ADAAMAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AeQB1AG4AZwBqAG8AbwAuAGgAYQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{66DE4051-15F9-4C8E-84CA-9CB825FD5596};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:33:26
 GMT;WwBQAEEAVABDAEgAXQAgAGUAeAB0AGMAbwBuADoAIABSAGUAbQBvAHYAZQAgAGMAYQBzAHQAaQBuAGcAIAB0AGgAZQAgAHIAZQB0AHUAcgBuACAAdgBhAGwAdQBlACAAdwBoAGkAYwBoACAAaQBzACAAYQAgAHYAbwBpAGQAIABwAG8AaQBuAHQAZQByAA==
x-cr-puzzleid: {66DE4051-15F9-4C8E-84CA-9CB825FD5596}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zI901sbpBBnu36Fhc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+Phji9MBT/4Kva+kWxgnMvT
	xcjJISFgIrF5+m92CFtM4sK99WxdjFwcQgLLGCW6n95kgyl6t+kUM0RiEaPEyvkvWCCcX4wS
	zw/tZgapYhNQk/jy5TDYKBEBXYmXV2+DxZkF8iSmHNkFZgsLBEi0357JCGKzCKhKXPq1EGwD
	r4CtRF/zamYIW1Dix+R7LBC9WhLrdx5ngrDlJTaveQtUwwF0kbrEo7+6EKv0JLbuvckKUSIi
	se/FO0aQ2yQEtrBKPJm6nRniA1OJ7//fsEAkdrFLvJ7/DeoIAYlvkw+xQAyVldh0AKpeUuLg
	ihssExglZiE5aRaSk2YhOWkWkt0LGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoTE4IQd
	jPcOWB9iTAZaP5FZSjQ5HxjDeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphak
	FsUXleakFh9iZOLglGpgXKzL+6s8Nvmb8YSlnCq9v6ZdkeSUvxu5KvptQAq3fnh8SZJpmzLv
	+/4VF6rm7NV+9KREuvHHNPVw3ZiUS6+b9QUOliVtmnf1ioq3LeMdDtmkNHGrh7HXV5xadWtl
	ys5Wz+OHJA+w1241mcG1Y67AZfn3cU7J91kZ4tdv8rU7M/N0PKOMo9lRJZbijERDLeai4kQA
	wSMuiNcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd01sbpBBvO2aFhc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB2iTkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwjjHj4Y4vTAU/+Cr2vpFsYJzL08XIySEhYCLxbtMpZghbTOLCvfVsXYxcHEICixglVs5/
	wQLh/GKUeH5oN1gVm4CaxJcvh9lBbBEBXYmXV2+DxZkF8iSmHNkFZgsLBEi0357JCGKzCKhK
	XPq1kA3E5hWwlehrXs0MYQtK/Jh8jwWiV0ti/c7jTBC2vMTmNW+BajiALlKXePRXF2KVnsTW
	vTdZIUpEJPa9eMcIcpuEwBZWiSdTt0N9YCrx/f8blgmMQrOQrJiFZMUsJCtmIZm1gJFlFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwhD+T3sG4qsHiEKMAB6MSD+8NQd0gIdbEsuLK3EOM
	EhzMSiK855/rBAnxpiRWVqUW5ccXleakFh9iTAaGwERmKdHkfGDyySuJNzQ2MTOyNDKzMDIx
	NydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRtN1YR8kk3qer2jKlN/YWc981V1r/y0/
	9oaPKUIcP/wCtvFrfs5sDWqIbnPwuLBUdpuS8PUt0WURPE8YZvyZFP5qtVCrj/gPowsJm+fe
	87zTpvfpqObWpk3bL7J+ZV6i9+8b164J/4+tFZyW+6PsdjaH7JXFwvy1IatzFyaslPjLuH0f
	g7v+IiWW4oxEQy3mouJEAGVhZRc0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-class.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 148382f..424788d 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -105,7 +105,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	int i, count = 0;
-	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+	struct extcon_dev *edev = dev_get_drvdata(dev);
 
 	if (edev->print_state) {
 		int ret = edev->print_state(edev, buf);
@@ -135,7 +135,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 {
 	u32 state;
 	ssize_t ret = 0;
-	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+	struct extcon_dev *edev = dev_get_drvdata(dev);
 
 	ret = sscanf(buf, "0x%x", &state);
 	if (ret == 0)
@@ -153,7 +153,7 @@ static DEVICE_ATTR_RW(state);
 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+	struct extcon_dev *edev = dev_get_drvdata(dev);
 
 	/* Optional callback given by the user */
 	if (edev->print_name) {
@@ -470,7 +470,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 			return -ENODEV;
 		class_dev_iter_init(&iter, extcon_class, NULL, NULL);
 		while ((dev = class_dev_iter_next(&iter))) {
-			extd = (struct extcon_dev *)dev_get_drvdata(dev);
+			extd = dev_get_drvdata(dev);
 
 			if (extcon_find_cable_index(extd, cable_name) < 0)
 				continue;
-- 
1.7.10.4


