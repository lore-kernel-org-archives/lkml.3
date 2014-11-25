Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaKYNIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:08:32 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:55418 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752647AbaKYNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:08:28 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <catalin.marinas@arm.com>,
        <gregkh@linuxfoundation.org>, <ijc+devicetree@hellion.org.uk>,
        <jslaby@suse.cz>, <galak@codeaurora.org>, <broonie@linaro.org>,
        <mark.rutland@arm.com>, <m-karicheri2@ti.com>, <pawel.moll@arm.com>,
        <artagnon@gmail.com>, <rrichter@cavium.com>, <will.deacon@arm.com>,
        <arnd@arndb.de>, <gnomes@lxorguk.ukuu.org.uk>, <corbet@lwn.net>,
        <jason@lakedaemon.net>, <broonie@kernel.org>, <heiko@sntech.de>,
        <shawn.guo@freescale.com>, <florian.vaussard@epfl.ch>,
        <andrew@lunn.ch>, <hytszk@gmail.com>, <orsonzhai@gmail.com>,
        <geng.ren@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <lanqing.liu@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>,
        <linux-doc@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: [PATCH v3 1/5] Documentation: DT: Renamed of-serial.txt to 8250.txt
Date: Tue, 25 Nov 2014 20:16:54 +0800
Message-ID: <1416917818-10506-2-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.103]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com sAPCI044064896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file of-serial.txt was only for 8250 compatible UART implementations,
so renamed it to 8250.txt to avoid confusing other persons.
This is recommended by Arnd, see:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/291455.html

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)

diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/8250.txt
similarity index 100%
rename from Documentation/devicetree/bindings/serial/of-serial.txt
rename to Documentation/devicetree/bindings/serial/8250.txt
-- 
1.7.9.5

