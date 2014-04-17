Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaDQIpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:45:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54316 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754307AbaDQIpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:45:33 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add GPIO nodes for Berlin BG2 and BG2CD
Date: Thu, 17 Apr 2014 10:45:27 +0200
Message-Id: <1397724329-14154-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After adding support for the Berlin BG2Q GPIOs, this series uses the
same GPIO dwapb driver to support the Berlin BG2 and BG2CD GPIOs.

Applies on top of Sebastian's for-next branch[1].

[1] https://github.com/shesselba/linux-berlin/commits/berlin/for-next

Antoine Ténart (2):
  ARM: dts: berlin: add the BG2 GPIO nodes
  ARM: dts: berlin: add the BG2CD GPIO nodes

 arch/arm/boot/dts/berlin2.dtsi   | 105 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/berlin2cd.dtsi | 102 +++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+)

-- 
1.8.3.2

