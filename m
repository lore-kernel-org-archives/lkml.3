Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3IWJr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:47:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29458 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IWJrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:47:24 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-55-52400e2b3210
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Alexander Holler'" <holler@ahsoftware.de>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 09/15] rtc: hid-sensor-time: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:47:23 +0900
Message-id: <002501ceb841$e7a30a50$b6e91ef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAATXJg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI11tPocgg+9PzS2WXLzKbjFn/Ro2
	i3/du5gsLi+8xGpxedccNov9nR2MDmweszsb2Dz2TDzJ5nFixm8Wj74tqxg9ps/7yeTxeZNc
	AFsUl01Kak5mWWqRvl0CV8b5E53sBUu4Kh6v+MHewPiYo4uRg0NCwERi2jfZLkZOIFNM4sK9
	9WxdjFwcQgLLGCXWPJrFDpEwkfhy8AojRGI6o8TNmzOZIJxfjBInn28Hq2ITUJP48uUwO8hU
	EQF9ibYWDZAaZoFdjBKrHu5iAakRErCVmDjtKxOIzSlgJ7Hm8zIwW1jAWWLDopusIDaLgKrE
	6sfLWUDm8ALVN3+LBgnzCghK/Jh8D2wMs4CWxOZtTawQtrzE5jVvmSGeUZd49FcXJCwiYCRx
	8N5uNogSEYl9L96B3S8h8JVd4sX1M4wQqwQkvk0+xALRKyux6QAzxL+SEgdX3GCZwCgxC8nm
	WUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTuxB2M9w9YH2JMBlo/
	kVlKNDkfGPt5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamBMWzix5/NVHlb9FrXfq73y5D6rmDzgEtjhqvb74bvOKww6Fdcq1kSfEJP8Ne3Jv4qL
	V3eErI2LaHwo2D17SdOG1UtjFUOPXDPw/M8adZMt7Fq0gvBSK6lP/au8tURcLln6thmdrRFb
	eGvOYyeG1F81ht7n+mYnycj2LU1fcT0o58RtS5v2UylKLMUZiYZazEXFiQC70u5W8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV1tPocgg+3PjS2WXLzKbjFn/Ro2
	i3/du5gsLi+8xGpxedccNov9nR2MDmweszsb2Dz2TDzJ5nFixm8Wj74tqxg9ps/7yeTxeZNc
	AFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM8yc62QuWcFU8XvGDvYHx
	MUcXIyeHhICJxJeDVxghbDGJC/fWs3UxcnEICUxnlLh5cyYThPOLUeLk8+3sIFVsAmoSX74c
	BrI5OEQE9CXaWjRAapgFdjFKrHq4iwWkRkjAVmLitK9MIDangJ3Ems/LwGxhAWeJDYtusoLY
	LAKqEqsfL2cBmcMLVN/8LRokzCsgKPFj8j2wMcwCWhKbtzWxQtjyEpvXvGUGKZcQUJd49FcX
	JCwiYCRx8N5uNogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMGp4Zn0DsZVDRaHGAU4GJV4eCMT7YOEWBPLiitzDzFKcDArifD6sToECfGm
	JFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MG3llcQbGpuYGVkamVkYmZibkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVANjsUC6BeveStYveW0tV8wP74hf5JigU+jWWbhJ+brv3GWxe9h1
	Tt7f+U6nI+PhNJfp7M/Utd8X3tnuvz3/3Xvv/ZEFTv13bhifaupa57nnp2WZWMOOWYs8T7Tc
	7Hrhl177fosDu9/h7he6XazTAjfkmSX6XH+wqtKglEMqfH90/0/GmJ0398UrsRRnJBpqMRcV
	JwIA4KDJx1EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-hid-sensor-time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index abbf5f3..22254f0 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -236,7 +236,7 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_sensor_hub_device *hsdev = dev_get_platdata(&pdev->dev);
 	struct hid_time_state *time_state = devm_kzalloc(&pdev->dev,
 		sizeof(struct hid_time_state), GFP_KERNEL);
 
@@ -298,7 +298,7 @@ static int hid_time_probe(struct platform_device *pdev)
 
 static int hid_time_remove(struct platform_device *pdev)
 {
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_sensor_hub_device *hsdev = dev_get_platdata(&pdev->dev);
 
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
-- 
1.7.10.4


