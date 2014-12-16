Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaLPSVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:21:51 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:50787 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaLPSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:21:49 -0500
Date: Tue, 16 Dec 2014 19:21:47 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: [PATCH v2 0/1] ARM: dts: kirkwood: enable phy driver for SATA
 controller on 88f6192
Message-ID: <20141216182147.GA19503@anne>
References: <20141215203724.GA22936@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215203724.GA22936@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:	indent with tabs only
	wrap change log at 80 chars

Evgeni Dobrev (1):
  enable phy driver for SATA controller on 88f6192

 arch/arm/boot/dts/kirkwood-6192.dtsi |    2 ++
 1 file changed, 2 insertions(+)

-- 
1.7.10.4

