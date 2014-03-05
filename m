Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbaCEDmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:42:07 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:59357 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244AbaCEDmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:42:02 -0500
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
Subject: [PATCH 5/5] ARM: multi_v7_defconfig: add st-keyscan driver
Date: Wed,  5 Mar 2014 04:39:32 +0100
Message-Id: <1393990772-9567-6-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
References: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds KEYBOARD_ST_KEYSCAN config

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
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

