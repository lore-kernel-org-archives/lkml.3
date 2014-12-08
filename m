Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaLHRFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:05:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:05:07 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-e8-5485da41fac4
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
        navneet kumar <navneetk@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v3 0/5] thermal: of: of-thermal.c API extensions
Date: Mon, 08 Dec 2014 18:04:16 +0100
Message-id: <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAV3HW60hBo/PSVo8XrOYyWLjjPWs
	Fl8+97FZzL9yjdVizV8lizePuC3ePNzMaHF51xw2i8+9Rxgtniw8w2Tx4Oo0Not9a5YyWTx5
	CFT/6mAbi8XPXfNYHPg9ds66y+6xeM9LJo91094ye/Q2v2Pz+DtrP4vHzu8N7B59W1Yxenze
	JOexcW5oAGcUl01Kak5mWWqRvl0CV8bE1VPYC5ZxVBzeeo6lgfExWxcjJ4eEgInEhw39zBC2
	mMSFe+uB4lwcQgKLGCXauxvBioQEupgkdt8Hs9kE9CQ+333KBGKLCHhLvN43nRGkgVlgDYvE
	h6t3wYqEBRwkLvW/ZgGxWQRUJX61N7GD2LwCbhLXTm+F2qwo0f1sApjNCRTfuKyZBWKZq8T2
	CdsYJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHMjPpHcwrmqwOMQowMGoxMO7
	8EFLiBBrYllxZe4hRgkOZiUR3uU7W0OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8964mRsiJJCe
	WJKanZpakFoEk2Xi4JRqYExxYtmmmJHssffW4ub2Btfjd1bUfNX8lL5j8/6M4MmpapLGFy9t
	cE5w+ZjgPr/2+6uNM1bPD3nBPHfdPNVNC5jTrae83GznI+5imKbVcohh/ezIKZPv5r6duWO5
	AZvnb5aKxIVb/fLihWrDju0SDEgX37gjeO0VPeZQl3nL914NOOS9M2jqE18lluKMREMt5qLi
	RAB98yxvYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provided patch series extend of-thermal.c file API. It is necessary 
for ongoing Exynos TMU rework.

First version of this code can be found at:
http://www.spinics.net/lists/linux-samsung-soc/msg37719.html

Second version:
http://www.spinics.net/lists/kernel/msg1872274.html

This code provides methods to access some of-thermal local data.
Moreover it provides a read only access to of-thermal trip points.

Lukasz Majewski (5):
  thermal: of: Extend of-thermal.c to provide number of trip points
  thermal: of: Extend of-thermal.c to provide check if trip point is
    valid
  thermal: of: Rename struct __thermal_trip to struct thermal_trip
  thermal: of: Extend of-thermal to export table of trip points
  thermal: of: Extend current of-thermal.c code to allow setting
    emulated temp

 drivers/thermal/of-thermal.c   | 109 ++++++++++++++++++++++++++++++++++-------
 drivers/thermal/thermal_core.h |  18 +++++++
 include/linux/thermal.h        |  18 +++++++
 3 files changed, 127 insertions(+), 18 deletions(-)

-- 
2.0.0.rc2

