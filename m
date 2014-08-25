Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbaHYOqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:16 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52181 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932697AbaHYOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:10 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [RESEND PATCH 0/4] Enables STMicroelectronics Flexgen Clock support
Date: Mon, 25 Aug 2014 16:44:44 +0200
Message-Id: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-25_01:2014-08-25,2014-08-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enables clock drivers for STih407 boards.

Gabriel Fernandez (4):
  ARM: STi: DT: STiH407: 407 DT Entry for clockgen A0
  ARM: STi: DT: STiH407: 407 DT Entry for clockgen C0
  ARM: STi: DT: STiH407: 407 DT Entry for clockgen D0/D2/D3
  ARM: STi: DT: STiH407: 407 DT Entry for clockgenA9

 arch/arm/boot/dts/stih407-clock.dtsi     | 295 ++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/stih407.dtsi           |  18 +-
 include/dt-bindings/clock/stih407-clks.h |  11 ++
 3 files changed, 307 insertions(+), 17 deletions(-)
 create mode 100644 include/dt-bindings/clock/stih407-clks.h

-- 
1.9.1

