Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbbANHaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:30:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbANHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:30:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3.18 118/150] ARM: defconfigs: use CONFIG_CPUFREQ_DT
Date: Tue, 13 Jan 2015 23:23:09 -0800
Message-Id: <20150114072101.197237474@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 9d312cd12e89ce08add99fe66e8f6baeaca16d7d upstream.

CONFIG_GENERIC_CPUFREQ_CPU0 disappeared with commit bbcf071969b20f
("cpufreq: cpu0: rename driver and internals to 'cpufreq_dt'") and some
defconfigs are still using it instead of the new one.

Use the renamed CONFIG_CPUFREQ_DT generic driver.

Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/multi_v7_defconfig |    2 +-
 arch/arm/configs/shmobile_defconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -446,4 +446,4 @@ CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_LOCKUP_DETECTOR=y
 CONFIG_CRYPTO_DEV_TEGRA_AES=y
-CONFIG_GENERIC_CPUFREQ_CPU0=y
+CONFIG_CPUFREQ_DT=y
--- a/arch/arm/configs/shmobile_defconfig
+++ b/arch/arm/configs/shmobile_defconfig
@@ -176,5 +176,5 @@ CONFIG_CPU_FREQ_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
 CONFIG_CPU_THERMAL=y
-CONFIG_GENERIC_CPUFREQ_CPU0=y
+CONFIG_CPUFREQ_DT=y
 CONFIG_REGULATOR_DA9210=y


