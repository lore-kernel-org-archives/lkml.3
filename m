Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3BSPgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:36:54 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18630 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3BSPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:36:52 -0500
X-AuditID: cbfec7f4-b7f4c6d0000018de-4c-51239c123f6b
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 0/2] max77693-led driver
Date: Tue, 19 Feb 2013 16:36:15 +0100
Message-id: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJMWRmVeSWpSXmKPExsVy+t/xy7pCc5QDDdZtNrW4vGsOm0XPhq2s
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8fn2KpWA3c8W9C3fYGhifMnUxcnJICJhIPGy9zQxh
	i0lcuLeerYuRi0NIYCmjRNPL/VBOH5PEzqYHjCBVbAKaEn8332QDsUUE5CWe9N4AK2IW+Mgo
	8fT1WRaQhLCAvsSGf5fAxrIIqEpsuPcVrJlXwFlix4OZ7BDrFCW6n01gm8DIvYCRYRWjaGpp
	ckFxUnquoV5xYm5xaV66XnJ+7iZGiD+/7GBcfMzqEKMAB6MSD+8HR6VAIdbEsuLK3EOMEhzM
	SiK88y2VA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUw+q3cPLFRsPmCT+rrq3/upk9zmxjVJhN+
	aqqd47sPGQkL+/he3+vsOzL7xv/+b7se3HzJFWB9YddEje9PH+/vqnwbU2kQ658g8tnh2rHC
	BfmXhBKORP08m63+uazZ6dKSqpnVYl+kXexMj1rsSKprvJ0Y/2qquL5TCMNqx98s+VvvuVxl
	vVx0Q4mlOCPRUIu5qDgRALfFrCzFAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those two patches add max77693-led driver with device tree support.
Driver is exposed to user space as a V4L2 flash subdevice.
This subdevice should be registered by V4L2 driver of the camera device.

Changes for v2 are described in patch 2/2, thanks for review to Sylwester.
Additionally I have inserted missing description of the patch 1/2.
I have also added e-mail recipients according to MAINTENANCE file.

Regards
Andrzej



