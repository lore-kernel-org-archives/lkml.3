Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbaCRPEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:04:14 -0400
Received: from mx08-00178001.pphosted.com ([62.209.51.94]:44749 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbaCRPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:04:07 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH v2 5/5] ARM: multi_v7_defconfig: add ST Keyscan driver
Date: Tue, 18 Mar 2014 16:00:06 +0100
Message-Id: <1395154806-2810-6-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395154806-2810-1-git-send-email-gabriel.fernandez@st.com>
References: <1395154806-2810-1-git-send-email-gabriel.fernandez@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-18_05:2014-03-18,2014-03-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds KEYBOARD_ST_KEYSCAN config

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index ee69829..5e926981 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -131,6 +131,7 @@ CONFIG_INPUT_EVDEV=y
 CONFIG_KEYBOARD_GPIO=y
 CONFIG_KEYBOARD_TEGRA=y
 CONFIG_KEYBOARD_SPEAR=y
+CONFIG_KEYBOARD_ST_KEYSCAN=y
 CONFIG_KEYBOARD_CROS_EC=y
 CONFIG_MOUSE_PS2_ELANTECH=y
 CONFIG_INPUT_MISC=y
-- 
1.9.0

