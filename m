Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965937AbaFRKcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:32:45 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35113 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbaFRKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:32:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org
Subject: [PATCH] ARM: stih41x: Rename stih416-b2020-revE.dts to stih416-b2020e.dts
Date: Wed, 18 Jun 2014 11:31:48 +0100
Message-Id: <1403087508-6710-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two reasons for this rename.  Firstly, it removes the camel case
convention which isn't used by any other platform and secondly it
matches the naming convention for the internal kernel, which can
become annoying when flipping between the two.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} (100%)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020e.dts
similarity index 100%
rename from arch/arm/boot/dts/stih416-b2020-revE.dts
rename to arch/arm/boot/dts/stih416-b2020e.dts
-- 
1.8.3.2

