Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3IWBg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:36:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48656 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3IWBg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:36:26 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-8c-523f9b193062
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
In-reply-to: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
Subject: [PATCH 2/4] misc: ibmasm: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:36:24 +0900
Message-id: <003301ceb7fd$50c91f50$f25b5df0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac63/SHKB4kHrvrSQPCGprHejMhtRAAAA6WA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA13J2fZBBrv+c1v8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErowzL2ez
	FVxhr3iy4hd7A+NWti5GTg4JAROJb0fmMkHYYhIX7q0HinNxCAksY5Q4deUcO0zRpcOnWUBs
	IYFFjBL9f0Qhin4xSiy8+ApsEpuAmsSXL4fBGkQETCU2vp/CCGIzC6RL3DnayQTRbCuxdONS
	ZhCbU8BO4t3Pn2C2sIC7RMtciF4WAVWJlav/g9m8QPWrln5lhrAFJX5MvscCMVNLYv3O40wQ
	trzE5jVvgWo4gA5Vl3j0VxfiBCOJjfemQ5WLSOx78Y4R4pdj7BKbF8lArBKQ+Db5EAtEq6zE
	pgPMECWSEgdX3GCZwCgxC8niWUgWz0KyeBaSDQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn
	525ihMRk/w7GuwesDzEmA62fyCwlmpwPjOm8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTAeFV+090n2UqXo7V7ZneG3mJ7afl43PeGuPuPWC07K
	ZlVyV0tbOQVX/azcWnhlgivb0TZfzsO73kS/5rogySfy2Ydl83GGonkZWz9e/jWFb4Xfy/Kz
	hfv7F/x192Y9V5hu9zHJXVRbQWzGmScxKhyPy6u7VWXU7pSXt52tfqZznTX+gVLcdG0lluKM
	REMt5qLiRADCOCj63wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV3J2fZBBneucFj8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMMy9nsxVcYa94suIXewPjVrYuRk4OCQETiUuHT7NA2GISF+6t
	B4sLCSxilOj/I9rFyAVk/2KUWHjxFViCTUBN4suXw+wgtoiAqcTG91MYQWxmgXSJO0c7mSCa
	bSWWblzKDGJzCthJvPv5E8wWFnCXaJkL0csioCqxcvV/MJsXqH7V0q/MELagxI/J91ggZmpJ
	rN95nAnClpfYvOYtUA0H0KHqEo/+6kKcYCSx8d50qHIRiX0v3jFOYBSahWTSLCSTZiGZNAtJ
	ywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwTH/TGoH48oGi0OMAhyMSjy8EYn2QUKs
	iWXFlbmHGCU4mJVEeJs6gUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xHeSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKLbg598/IcYLFz/4kJTOaGx2
	7c6tJ99k1iobP85wcSmq2J6dn+TD/3vG3Xf3pLL0VctTc/4otzcFXphW9qX1zdsJ6w8Wfjw7
	7e3kRXOaRXleLVjxaE//o0fL+lIDjpvOmbBA45HojWlHHmd7nTfMdouwtVB4nygrvz7+x96T
	h9oslFZcDGM7fl2JpTgj0VCLuag4EQAyLb4iPQMAAA==
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
 drivers/misc/ibmasm/module.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index 0346d87..c224039 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -153,7 +153,6 @@ error_ioremap:
 error_heartbeat:
 	ibmasm_event_buffer_exit(sp);
 error_eventbuffer:
-	pci_set_drvdata(pdev, NULL);
 	kfree(sp);
 error_kmalloc:
         pci_release_regions(pdev);
@@ -182,7 +181,6 @@ static void ibmasm_remove_one(struct pci_dev *pdev)
 	ibmasm_free_remote_input_dev(sp);
 	iounmap(sp->base_address);
 	ibmasm_event_buffer_exit(sp);
-	pci_set_drvdata(pdev, NULL);
 	kfree(sp);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
1.7.10.4


