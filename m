Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaLVIEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:04:06 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:46310 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaLVIEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:04:04 -0500
Date: Mon, 22 Dec 2014 09:04:00 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 0/1] add support for Seagate BlackArmor NAS220
Message-ID: <20141222080400.GA15278@anne>
References: <20141215203855.GA28940@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215203855.GA28940@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:	indent with tabs only
	removed NAND layout

Evgeni Dobrev (1):
  add support for Seagate BlackArmor NAS220

 arch/arm/boot/dts/Makefile            |    1 +
 arch/arm/boot/dts/kirkwood-nas220.dts |  158 +++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)
 create mode 100644 arch/arm/boot/dts/kirkwood-nas220.dts

-- 
1.7.10.4

