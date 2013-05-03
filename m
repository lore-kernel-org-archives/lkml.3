Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662Ab3ECG1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:27:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62777 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762457Ab3ECG13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:27:29 -0400
X-AuditID: cbfee691-b7fe56d000004b96-69-518358cfc1d8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>,
        "'Mike Frysinger'" <vapier.adi@gmail.com>
Subject: [PATCH 09/42] rtc: rtc-bfin: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:27:27 +0900
Message-id: <001701ce47c7$484e7b50$d8eb71f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxzViCOzvm775TnmF6l0QtRiqZw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zfd3zEc2BBs92m1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORosDC9+zOLB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGU8/q5bMJet4s68JcwNjBNZuxg5OSQETCTe9KyBssUkLtxbz9bF
	yMUhJLCMUeLpjE9wRS9vHWeFSCxilJj6/ilU1S9GiZs7pjKBVLEJqEl8+XKYvYuRg0NEQF+i
	rUUDpIZZYBujROP/BrAaYQF/iXPXfjOD2CwCqhJ3T31gB7F5BSwltu7YwwhhC0r8mHyPBcRm
	FtCSWL/zOBOELS+xec1bZoiLFCR2nH3NCLFLT2LvZk2IEhGJfS/eMYLslRC4xC7xcu5/Fohd
	AhLfJh9iAamXEJCV2HQAaoykxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelF
	pnrFibnFpXnpesn5uZsYIdE4cQfj/QPWhxiTgdZPZJYSTc4HRnNeSbyhsZmRhamJqbGRuaUZ
	acJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhinXDVikzDf6VfyRNe7acLMkzdK
	r4S6CXBuEY5W37FlA9OSzbXP1P55OtbcjWJwKuR58Epkpv4jgUUGCkZ9mlGXd2SqNp7etiq6
	0OPJu0qRr5+Uf6to1Db+yfyVddrUdJqH+1S/nouiFy/8/LdIKnbqrs1fLv02VFU69HqT/P3a
	Vvk/6+WEq/4rsRRnJBpqMRcVJwIAcOPZd9wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd3zEc2BBrt/GVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORosDC9+zOLB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMePxdt2AuW8WdeUuYGxgn
	snYxcnJICJhIvLx1HMoWk7hwbz1bFyMXh5DAIkaJqe+fQjm/GCVu7pjKBFLFJqAm8eXLYfYu
	Rg4OEQF9ibYWDZAaZoFtjBKN/xvAaoQF/CXOXfvNDGKzCKhK3D31gR3E5hWwlNi6Yw8jhC0o
	8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khLlKQ2HH2NSPELj2JvZs1IUpEJPa9eMc4gVFgFpJJ
	s5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf6M+kdjKsaLA4xCnAw
	KvHwKrQ0BQqxJpYVV+YeYpTgYFYS4XX7ARTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGAa
	yiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRp38q08eiOSZ
	PmtQ7N+6ejfXwxMzPi2bOnPDjV8X5t35pWTeu1Du5OSFwZk+xX9ZF5y8WxB9JW/xpKKzE89e
	5Lz5M73ff7bK4Wc7Xxgpva0v3P79xY3FFvPuNW7k5Vzy0XbWx8rbqZFuU2uKXujVdTrqS2b7
	eZZOzlg8O0z9h3sZz9adx5gXHr6vxFKckWioxVxUnAgAEVA80TkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-bfin.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index ad44ec5..0c53f45 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -391,7 +391,6 @@ static int bfin_rtc_remove(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	bfin_rtc_reset(dev, 0);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


