Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaIKMyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:54:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22939 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaIKMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:54:28 -0400
X-AuditID: cbfee691-f79546d0000011a1-21-54119b82b157
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v4 0/4] Add max77693 haptic driver
Date: Thu, 11 Sep 2014 21:54:18 +0900
Message-id: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsWyRsSkWLdptmCIwas/WhbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGloUnGAs28lSc2LCCrYFxA2cXIweHhICJxLzZnl2MnECmmMSFe+vZ
	QGwhgaWMEl3zIiDiJhKHe5oYIeKLGCU2vo7vYuQCstuYJLpW/QZrYBPQlvi+fjEriC0iUCnR
	3/2CFaSIWaCHUWLpqqXsIAlhASOJzY2HmEFsFgFViQdPz7OA2LwCHhLNj+YzQxykIDFnkg1I
	r4TAfzaJy1C9LAICEt8mH2KBqJGV2HSAGeI4SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IVK84
	Mbe4NC9dLzk/dxMjMFxP/3s2cQfj/QPWhxgFOBiVeHgrWARDhFgTy4orcw8xmgJtmMgsJZqc
	D4yKvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGPOK
	PnHv7BJv+mJ4LV6b/fTduV2Hsm49sFLcKHRpXVCq/WbxfWdXTbg5U2CNTsCy0+dtzmWe52cO
	b//yZvEFpT8/ykNFzWPUFzpsdn7sVPVz5qIFNpbzLxXKv4z4U1S3hC0p5jr321Pu3152rolN
	bJ162/x32lbtK3t6PQr7j4WIiV96u2r6qadKLMUZiYZazEXFiQA3DYQIUgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xgG7TbMEQg5UPlC2uf3nOanF40QtG
	ix0NR1gt7n89ymhx89M3VovLu+awWZzuZnVg99g56y67x51re9g85p0M9OjbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGVsWnmAs2MhTcWLDCrYGxg2c
	XYycHBICJhKHe5oYIWwxiQv31rOB2EICixglNr6O72LkArLbmCS6Vv0GS7AJaEt8X7+YFcQW
	EaiU6O9+wQpSxCzQwyixdNVSdpCEsICRxObGQ8wgNouAqsSDp+dZQGxeAQ+J5kfzgeIcQNsU
	JOZMspnAyL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBEPJPawbiyweIQowAHoxIP
	bwWLYIgQa2JZcWXuIUYJDmYlEd4b04FCvCmJlVWpRfnxRaU5qcWHGE2Blk9klhJNzgdGa15J
	vKGxiZmRpZG5oYWRsbmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsZmqdUaH3/IX18578n5
	nQbtbxL4fu1T1GlqvPbiwOLLR/bOi7/dvvTAYuPpemIO8i/ERQpWui8LuTn9wipL2e9mJo3+
	do1xXedfVfv8PRy3YbNu/aoLBiv8q91e/fExWKbsFLl9Jv+fDOMHMZ78z+oy/edOEbqvvDH0
	bq9jn8o3xYLWn7fX8RgpsRRnJBpqMRcVJwIAQmub3Z4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds max77693 haptic driver.
The max77693 is a Multifunction device with PMIC, CHARGER, LED,
MUIC, HAPTIC and this series is haptic device driver in MAX77693.
The haptic driver use regmap method for i2c communication and
support force feedback framework in input device.

Changes in v4:
 - mfd : fix tabbing in mfd_cell
 - driver : move regulator enable/disable to input open()/close()
 - driver : add resume function

Changes in v3:
 - driver : remove mutex in workqueue
 - driver : mv max77693_haptic_set_duty_cyle() to workqueue.
 - driver : remove max77693_haptic_remove[]
 - driver : add suspend() function to turn-off entering suspend.

Changes in v2:
 - split to documentation and mfd patchs.
 - Documentation : change explanation of haptic 
 - Documentation : remove pwm-names propertie in example

Jaewon Kim (4):
  mfd: max77693: Initialize haptic register map
  Input: misc: Add haptic driver on max77693
  mfd: max77693: add haptic of_compatible in mfd_cell
  mfd: max77693: Update DT binding to support haptic

 Documentation/devicetree/bindings/mfd/max77693.txt |   18 +
 drivers/input/misc/Kconfig                         |   12 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/max77693-haptic.c               |  354 ++++++++++++++++++++
 drivers/mfd/max77693.c                             |   26 +-
 include/linux/mfd/max77693-private.h               |    9 +
 6 files changed, 416 insertions(+), 4 deletions(-)
 create mode 100644 drivers/input/misc/max77693-haptic.c

-- 
1.7.9.5

