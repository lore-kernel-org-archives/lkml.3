Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaHZPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:40:56 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45480 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbaHZPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:40:55 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iivanov@mm-sol.com,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 0/2] ARM: dts: qcom: Add initial IFC6540 board support
Date: Tue, 26 Aug 2014 18:39:36 +0300
Message-Id: <1409067578-30272-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic support for the IFC6540 single-board computer boards, that are
based on the APQ8084 SoC. The first patch adds the initial device tree
and the second enables the serial console.

Should go through the qcom/arm-soc tree.

Georgi Djakov (2):
  ARM: dts: qcom: Add initial IFC6540 board device tree
  ARM: dts: qcom: Enable serial port on IFC6540 boards

 arch/arm/boot/dts/Makefile                 |    1 +
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   12 ++++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts

-- 
1.7.9.5

