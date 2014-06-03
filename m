Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaFCHdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:33:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43976 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932292AbaFCHdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:33:13 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: berlin: BG2Q I2C support
Date: Tue,  3 Jun 2014 09:33:08 +0200
Message-Id: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the I2C nodes for the Marvell Berlin BG2Q SoC. It also
enables I2C0 and I2C2 for the BG2Q DMP.

The Marvell Berlin BG2Q has 4 TWSI compatible with the Synopsys
DesignWare I2C driver.

Antoine Ténart (2):
  ARM: dts: berlin: add I2C nodes for BG2Q
  ARM: dts: berlin: enable i2c0 and i2c1

 arch/arm/boot/dts/berlin2q-marvell-dmp.dts |  8 ++++
 arch/arm/boot/dts/berlin2q.dtsi            | 72 ++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

-- 
1.9.1

