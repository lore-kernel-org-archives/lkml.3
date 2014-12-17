Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaLQKDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:03:49 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51880 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbaLQKDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:03:46 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, benjamin.gaignard@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 0/2] Enable DRM/KMS support for STiH407 Family boards
Date: Wed, 17 Dec 2014 11:02:22 +0100
Message-Id: <1418810544-11405-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_03:2014-12-17,2014-12-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set Enable DRM/KMS support for STiH407 Family boards.

Gabriel Fernandez (2):
  ARM: DT: STiH407: Add DRM dt nodes
  ARM: DT: STiH407: Specify default clocks for HDMI devices

 arch/arm/boot/dts/stih407-family.dtsi | 139 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stihxxx-b2120.dtsi  |   2 +-
 2 files changed, 140 insertions(+), 1 deletion(-)

-- 
1.9.1

