Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaDYJKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:10:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaDYJIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:08:22 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-cd-535a2600291d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, cw00.choi@samsung.com,
        jkosina@suse.cz, labbe.montjoie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] devfreq: Support resource management functions and code
 clean
Date: Fri, 25 Apr 2014 18:08:09 +0900
Message-id: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkSJdBLSrYoGMDp8X1L89ZLXbPWcxi
	cbbpDbvF+gUL2Swu75rDZvG59wijxe3GFWwWb36cZbJ4vOItuwOnx85Zd9k9Fu95yeTRt2UV
	o8eZBUfYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfGtYuH2QqOcVQc/LyVuYFxCnsXIyeH
	hICJxNUFR9kgbDGJC/fWA9lcHEICSxklbk5YxQxT9Ot9G1RiEaPEnH9HWSGcJiaJY19+glWx
	CWhJ7H9xA2yUiIC5xK6lP8FsZoHljBJb54aB2MICIRIPnt0Fi7MIqEpM3zUfrJdXwEWi7cU+
	JohtchIf9jxiB1kgITCZXWLC6152iAYBiW+TD7F0MXIAJWQlNh2Auk5S4uCKGywTGAUXMDKs
	YhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM69P/nvXuYLx9wPoQYzLQuInMUqLJ+cC4yCuJ
	NzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxjk5k935
	13W4OM8Jr/NYGxD57uJptd/2H7TtXzrIFVZeMeM56f4xs/n6+vAIDtulcWLS3Sb92RPOquYV
	s6xiK/3/wfnfNfbU1YZ1h5+3xASmMX+WM+/+0lHxKbN04QM5gw87b9cx8qTMD333fOq2No7f
	l34/k8xjSmtrTnW4P3eCFU/GiQciSizFGYmGWsxFxYkAqW8Y0YECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jAd3/qlHBBj9W2lhc//Kc1WL3nMUs
	Fmeb3rBbrF+wkM3i8q45bBafe48wWtxuXMFm8ebHWSaLxyvesjtweuycdZfdY/Gel0wefVtW
	MXqcWXCE3eP4je1MHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAnaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxh
	zLh28TBbwTGOioOftzI3ME5h72Lk5JAQMJH49b6NDcIWk7hwbz2QzcUhJLCIUWLOv6OsEE4T
	k8SxLz+ZQarYBLQk9r+4AdYhImAusWvpTzCbWWA5o8TWuWEgtrBAiMSDZ3fB4iwCqhLTd80H
	6+UVcJFoe7GPCWKbnMSHPY/YJzByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHDXP
	pHcwrmqwOMQowMGoxMM7QTYyWIg1say4MvcQowQHs5II7wyJqGAh3pTEyqrUovz4otKc1OJD
	jMlA2ycyS4km5wMjOq8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4
	OKUaGJu2lUZxiPM9ePlMw87d9RRTdvnbglnz1H37FY4/bjx5aUtS6fe7vgYPn4lnta4MD7K7
	0SHM5f/fbeEKDtuHwqzbtH6wcs3xCNj0K8h65vE3Mn/vS+v2yr9mf2Bv+oLFM3rHkmKmBd9a
	Ve2FfuatCnFMPf3pEMNFttWV6bdfXeqYGlzKNmPpdCWW4oxEQy3mouJEAPuuwCneAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix devfreq_remove_device() to remove duplicate function call
of _remove_devfreq() and add following functions for the resource management
of devfreq device and simpify the control of resource on exynos4_bus/exynos5_bus
driver.
- devm_devfreq_add_device
- devm_devfreq_remove_device
- devm_devfreq_register_opp_notifier
- devm_devfreq_unregister_opp_notifier

Chanwoo Choi (5):
  devfreq: Fix devfreq_remove_device() to improve the sequence of resource free
  devfreq: Add resource-managed function for devfreq device
  devfreq: Add devm_devfreq_{register,unregister}_opp_notfier function
  devfreq: exynos4: Use devm_devfreq_* function using device resource management
  devfreq: exynos5: Use devm_devfreq_* function using device resource management

 drivers/devfreq/devfreq.c            | 125 ++++++++++++++++++++++++++++++++---
 drivers/devfreq/exynos/exynos4_bus.c |  19 ++----
 drivers/devfreq/exynos/exynos5_bus.c |  23 +++----
 include/linux/devfreq.h              |  35 +++++++++-
 4 files changed, 161 insertions(+), 41 deletions(-)

-- 
1.8.0

