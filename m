Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaLXDPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:15:55 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7427 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaLXDOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:14:00 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>
CC: <arnd@arndb.de>, <yanhaifeng@gmail.com>, <zhangfei.gao@linaro.org>,
        <haojian.zhuang@linaro.org>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 4/7] ARM: config: enable ARCH_HIP01
Date: Wed, 24 Dec 2014 03:09:59 +0000
Message-ID: <1419390602-193123-5-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
References: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.549A2F3D.0224,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 2dd43eb092b1aaf509cd0dd673f1dc79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make hip01 share the hisi_defconfig.
And add it into multi_v7_defconfig too.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/configs/hisi_defconfig     | 1 +
 arch/arm/configs/multi_v7_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/configs/hisi_defconfig b/arch/arm/configs/hisi_defconfig
index 1125436..c34da58 100644
--- a/arch/arm/configs/hisi_defconfig
+++ b/arch/arm/configs/hisi_defconfig
@@ -8,6 +8,7 @@ CONFIG_ARCH_HI3xxx=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_CMDLINE_PARTITION=y
 CONFIG_ARCH_HIX5HD2=y
+CONFIG_ARCH_HIP01=y
 CONFIG_ARCH_HIP04=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=16
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 2328fe7..23523ed 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -32,6 +32,7 @@ CONFIG_ARCH_HIGHBANK=y
 CONFIG_ARCH_HISI=y
 CONFIG_ARCH_HI3xxx=y
 CONFIG_ARCH_HIX5HD2=y
+CONFIG_ARCH_HIP01=y
 CONFIG_ARCH_HIP04=y
 CONFIG_ARCH_KEYSTONE=y
 CONFIG_ARCH_MESON=y
-- 
1.8.3.4

