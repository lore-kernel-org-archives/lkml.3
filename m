Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbbANHG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:06:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:55290 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbANHG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:06:58 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <khilman@kernel.org>, <olof@lixom.net>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, <linuxarm@huawei.com>, <yanhaifeng@hisilicon.com>,
        <liguozhu@hisilicon.com>, <zhangfei.gao@linaro.org>,
        <haojian.zhuang@linaro.org>, <guodong.xu@linaro.org>,
        <sanil.kumar@huawei.com>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable Hip01 platform
Date: Wed, 14 Jan 2015 07:02:04 +0000
Message-ID: <1421218924-36924-1-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Hip01 platform support for multi_v7_defconfig.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index bc393b7..e5e0172 100644
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

