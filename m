Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaEML7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:59:30 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56911 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932401AbaEML72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:59:28 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [RFC] [PATCH 0/2] clock helper for determining flags properties
Date: Tue, 13 May 2014 13:57:31 +0200
Message-Id: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_03:2014-05-13,2014-05-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch provides a helper to get flags properties of a clock node.
This patch is limited to CLK_SET_RATE_PARENT flag for e.g.

The second patch provides an example of use of this clock helper.

Gabriel Fernandez (2):
  clk: of: helper for determining flags properties
  drivers: clk: st: authorize propagate rate change for clockgenD0

 arch/arm/boot/dts/stih407-clock.dtsi |  1 +
 drivers/clk/clk.c                    | 11 +++++++++++
 drivers/clk/st/clk-flexgen.c         |  2 ++
 include/linux/clk-provider.h         |  6 ++++++
 4 files changed, 20 insertions(+)

-- 
1.9.1

