Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaL1Kqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 05:46:33 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:39626 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL1Kqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 05:46:31 -0500
Date: Sun, 28 Dec 2014 11:46:27 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 0/1] add support for Seagate BlackArmor NAS220
Message-ID: <20141228104627.GA11475@anne>
References: <20141215203855.GA28940@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215203855.GA28940@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4:	rename basename to blackarmor-nas220
	use "Seagate Blackarmor NAS220" as model name
	use node references instead of repeating the bus structure
	separate nodes with blank lines
	adt7476's node name reflects device function (i.e. thermal)
	reduce button labels to "Reset" and "Power"
	use GPIO_ACTIVE_LOW for regulator's gpio property

v3:	documented UART pinout in dts

v2:	indent with tabs only
	removed NAND layout

Evgeni Dobrev (1):
  add support for Seagate BlackArmor NAS220

 arch/arm/boot/dts/Makefile                       |    1 +
 arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts |  172 ++++++++++++++++++++++
 2 files changed, 173 insertions(+)
 create mode 100644 arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts

-- 
1.7.10.4

