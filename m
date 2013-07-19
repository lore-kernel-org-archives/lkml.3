Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab3GSHGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:06:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45980 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3GSHGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:06:19 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-7b-51e8e5691d3f
From: Jingoo Han <jg1.han@samsung.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] power: power: replace strict_strtol() with kstrtol()
Date: Fri, 19 Jul 2013 16:06:16 +0900
Message-id: <000d01ce844e$767b4a30$6371de90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ETf6RlW52SQ4GSw+Sm8cfdxLBTw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zA93Mpy8CDR5tFrM4uFXTYuLKycwW
	lxdeYrW4vGsOmwOLx4T+T4wem1doefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG7YmVBd9Y
	K3Yd+czewPiZpYuRk0NCwETiz5N2KFtM4sK99WwgtpDAMkaJ5w3SMDUt93oYIeLTGSUaJnh1
	MXIB2b8YJf7dW8IMkmATUJP48uUwO4gtAmSfvvySFcRmFsiWWLfmKNACDg5hAVeJX2/BdrEI
	qEqcWbMErIRXwFLi7oUdbBC2oMSPyfdYIFq1JNbvPM4EYctLbF7zlhniHgWJHWdfM0Ks0pP4
	Pv8Z1CoRiX0v3jGC3CYhsI5d4vHqJVDLBCS+TT4EdoOEgKzEpgNQcyQlDq64wTKBUWwWktWz
	kKyehWT1LCQrFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIia7eHYy3D1gfYkwGWj+R
	WUo0OR8YnXkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYJS9zvR7zXzNz+kuP/nfp2gE+STtvpf49Nqsnfu2c96/Kfnp16tc/90bEzTf2Gdlhjlv
	3RixxbXjvOiM+fPLIpxEX20xYrwV3WB0Z2n4Gcl/LY6v5bdIp6z6JXb1Te1Ep6M8tztP2iq8
	1FrNE/9BUTW36s6aUN5S56sfVzJ0Fytzd0dtbhN10FFiKc5INNRiLipOBADIOx+6xAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoG7m0xeBBq1vhSwObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcXtiZcE31opdRz6zNzB+Zuli5OSQEDCRaLnXwwhhi0lcuLeeDcQW
	EpjOKNEwwauLkQvI/sUo8e/eEmaQBJuAmsSXL4fZQWwRIPv05ZesIDazQLbEujVHgYZycAgL
	uEr8egs2n0VAVeLMmiVgJbwClhJ3L+xgg7AFJX5MvscC0aolsX7ncSYIW15i85q3zBD3KEjs
	OPuaEWKVnsT3+c+gVolI7HvxjnECo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIjt5nUjsYVzZYHGIU4GBU4uF98OV5oBBrYllxZe4hRgkOZiUR3l/JLwKF
	eFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YWPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgXHR4ZbVUZvKd+Y6PlvD/iFP5s7XJ3YaHE+NWNPiPoYzOKsG
	/OHQOnP58Z3rXB+5Xn20n6UVIFxRbrS20GtO5rdlaW5iE4tt03RZoyo/9TRu/+my2aD/9BHr
	00GZR+Q/TLOx/6nV62N4qfR19o3b4ssi9eQSfzx8/9HtafjXyyJ5vk459/4ILFZiKc5INNRi
	LipOBADNBJlZIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtol() is not preferred, because
strict_strtol() is obsolete. Thus, kstrtol() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/power_supply_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 29178f7..44420d1 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -118,7 +118,7 @@ static ssize_t power_supply_store_property(struct device *dev,
 	long long_val;
 
 	/* TODO: support other types than int */
-	ret = strict_strtol(buf, 10, &long_val);
+	ret = kstrtol(buf, 10, &long_val);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.10.4


