Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaKTQVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:21:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31877 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbaKTQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:21:42 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-6e-546e1514a788
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 0/4] thermal: of: of-thermal.c API extensions
Date: Thu, 20 Nov 2014 17:21:24 +0100
Message-id: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAV0R0bwQg60P5Cwer1nMZLFxxnpW
	iy+f+9gs5l+5xmqx5q+SxZtH3BZvHm5mtLi8aw6bxefeI4wWTxaeYbJ4cHUam8WTh0Clrw62
	sVj83DWPxYHPY+esu+wei/e8ZPJYN+0ts0dv8zs2j7+z9rN47PzewO7Rt2UVo8fnTXIeG+eG
	BnBGcdmkpOZklqUW6dslcGW8W3SfvaCBveLMio9sDYxXWbsYOTkkBEwkzv7ph7LFJC7cW8/W
	xcjFISSwiFFixYY7TBBOF5PEnznXmEGq2AT0JD7ffcoEYosIeEu83jedEaSIWaCdReL6od2M
	IAlhAQeJPS+/sYDYLAKqEp3f94M18wq4SkzddIcFYp2iRPezCWwgNidQ/Onj1WA1QgIuErcf
	vWSfwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwAD+T3sG4qsHiEKMAB6MSD2+C
	RW6IEGtiWXFl7iFGCQ5mJRFeOfa8ECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8N24CVQukJ5ak
	ZqemFqQWwWSZODilGhhNZOse7FRvzAy5YK1tc8VeKrZl5s/ZLyWZHF9ViW74sdOBserz/em6
	R/gMFIo+PhNXOKLyU0DV/DN3r+3tnbu79dUEJ1ab24QZL2Y81lyWInLiY/kGReWHiUu5SrdP
	lNNkOezz7m9j3e3on5u+bBfyd93/teXyx+/pZ+OuLY7hjvf5r7Bjt7ISS3FGoqEWc1FxIgCm
	ScP7XAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provided patch series extend of-thermal.c file API. It is necessary 
for ongoing Exynos TMU rework.
First version of this code can be found at:
http://www.spinics.net/lists/linux-samsung-soc/msg37719.html

This code provides some methods to access some of-thermal local data.
Moreover it provides a read only copy of trip points.

Lukasz Majewski (4):
  thermal: of: Extend of-thermal.c to provide number of trip points
  thermal: of: Extend of-thermal.c to provide check if trip point is
    enabled
  thermal: of: Extend of-thermal to export table of trip points
  thermal: of: Extend current of-thermal.c code to allow setting
    emulated temp

 drivers/thermal/of-thermal.c   | 97 ++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/thermal_core.h | 17 ++++++++
 include/linux/thermal.h        | 15 +++++++
 3 files changed, 129 insertions(+)

-- 
2.0.0.rc2

