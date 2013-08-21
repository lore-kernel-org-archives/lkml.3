Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3HUJw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:52:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27040 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3HUJw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:52:57 -0400
X-AuditID: cbfee691-b7fef6d000002d62-93-52148df89ad6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] dma: ipu: remove unnecessary platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:52:54 +0900
Message-id: <003101ce9e54$35dc8910$a1959b30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6eVC7vkufHJSRuRVymIniUZAlp9g==
Content-language: ko
x-cr-hashedpuzzle: CuoK G3jq JGoB QAly Q2JF ST8/ UPh+ ZhSc iP9T qn9Z 0193 4RFs
 98TA /KJ4 AAhNLg==
 AA/41A==;7;YQBuAGQAcgBpAHkALgBzAGgAZQB2AGMAaABlAG4AawBvAEAAbABpAG4AdQB4AC4AaQBuAHQAZQBsAC4AYwBvAG0AOwBkAGoAYgB3AEAAZgBiAC4AYwBvAG0AOwBmAGEAYgBpAG8ALgBlAHMAdABlAHYAYQBtAEAAZgByAGUAZQBzAGMAYQBsAGUALgBjAG8AbQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcwBoAGEAdwBuAC4AZwB1AG8AQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAdgBpAG4AbwBkAC4AawBvAHUAbABAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Sosha1_v1;7;{F7057801-33A0-4274-A5A7-EEB128C82307};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 21 Aug 2013 09:52:44
 GMT;WwBQAEEAVABDAEgAXQAgAGQAbQBhADoAIABpAHAAdQA6ACAAcgBlAG0AbwB2AGUAIAB1AG4AbgBlAGMAZQBzAHMAYQByAHkAIABwAGwAYQB0AGYAbwByAG0AXwBzAGUAdABfAGQAcgB2AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {F7057801-33A0-4274-A5A7-EEB128C82307}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI90fvSJBBr3HWCx6m6YzWWzuf8Bm
	MatL1+LywkusFpd3zWGzeLpuCbPFy779LA7sHhOb37F7/Dvcz+SxeM9LJo871/awecw7GejR
	t2UVo8fnTXIB7FFcNimpOZllqUX6dglcGQ9fX2Qu2Mta0XHuDEsD41GWLkZODgkBE4nVU9az
	QdhiEhfugdhcHEICyxgler+3sXYxcoAVTZwTBBGfzijx5sVhJgjnF6PExgfP2EG62QTUJL58
	OcwO0iAioC6x9LoMSA2zwAwmiWPN58G2CQu4SGzs6GUFsVkEVCV2fNnJBGLzCthK/OmYwgJh
	C0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiIPUJR791YVYpSfR/jUfokJEYt+Ld4wgayUErrBJ
	NL/+xAjxmKnE1mv3oRI/2SX2rrjKBnGDgMS3yYdYIGbKSmw6wAxRLylxcMUNlgmMErOQXDQL
	yUWzkFw0C8nuBYwsqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzFConniDsb7B6wPMSYDrZ/I
	LCWanA9MBnkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYIxuk+pccdu6be/0hMlbHwj09vtEKFXkzVLK0z6ZNOGnZ8aRDaor12pHzD6x0vz0pH2X
	4tdniYkrRqauEEhQ6Pu2XEVLX9LOKlj/1YY8fzvbb7PuzXhla87203mj3c+ulDafX4LlE1We
	rxFL8s89d+GNxp3Xa2eFCjKEu2+d5fPGqMVU/eiOOiWW4oxEQy3mouJEABTmmmb8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd0fvSJBBku0LHqbpjNZbO5/wGYx
	q0vX4vLCS6wWl3fNYbN4um4Js8XLvv0sDuweE5vfsXv8O9zP5LF4z0smjzvX9rB5zDsZ6NG3
	ZRWjx+dNcgHsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+
	AbpumTlA5ygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMx6+vshcsJe1
	ouPcGZYGxqMsXYwcHBICJhIT5wR1MXICmWISF+6tZ+ti5OIQEpjOKPHmxWEmCOcXo8TGB8/Y
	QarYBNQkvnw5zA7SLCKgLrH0ugxIDbPADCaJY83nWUBqhAVcJDZ29LKC2CwCqhI7vuxkArF5
	BWwl/nRMYYGwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zxHHqEo/+6kKs0pNo/5oPUSEise/F
	O0aQtRICV9gkml9/YoR4wFRi67X7jBMYhWYh2TALyYZZSDbMQjJrASPLKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgRPFMagfjygaLQ4wCHIxKPLwXlEWChFgTy4orcw8xSnAwK4nwLqoG
	CvGmJFZWpRblxxeV5qQWH2JMBgbARGYp0eR8YBLLK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQbG7e8aHnb5Fl6Z8PDaq8ecAUezwkqZtLgCstelhmiWSX70
	vO59f/qhW2u8+StEDzzfcejktycZLFVs8VNefC5vE8nsOiB2M6LUpn5Zz2/bI6G82q3vpqtq
	798zKfPlOzOHMvNPh2ya/h38+NrXv+EFV2g255zI59bhLNxsAr1HAoK0Lt7+8aVEiaU4I9FQ
	i7moOBEA8DrZWFgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/ipu/ipu_idmac.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 608d4a2..cb9c0bc 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1764,7 +1764,6 @@ static int ipu_remove(struct platform_device *pdev)
 	iounmap(ipu->reg_ic);
 	iounmap(ipu->reg_ipu);
 	tasklet_kill(&ipu->tasklet);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.10.4


