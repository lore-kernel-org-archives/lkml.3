Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3G2RDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:03:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46778 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3G2RDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:03:41 -0400
From: Nishanth Menon <nm@ti.com>
To: Benoit Cousson <benoit.cousson@gmail.com>,
        Tony Lindgren <tony@atomide.com>
CC: l-o <linux-omap@vger.kernel.org>, dt list <devicetree@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/3] ARM: dts: omap5-uevm: fixup wrong regulator configuration
Date: Mon, 29 Jul 2013 12:03:00 -0500
Message-ID: <1375117383-19285-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <51F67D7D.9070003@ti.com>
References: <51F67D7D.9070003@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to wrong older revision of documentation used as reference, we
seem to have a bunch of LDOs wrongly configured on OMAP5 uEVM. This
series is based power tree on production board 750-2628-XXX platform.
Unfortunately, the wrong voltages may be detrimental to OMAP5 as they
supply hardware blocks at voltages that are out of specification.

Also available at:
based on v3.11-rc1 tag
http link: https://github.com/nmenon/linux-2.6-playground/commits/push/omap5-palmas-fixes-v2
git link: git://github.com/nmenon/linux-2.6-playground.git
branch: push/omap5-palmas-fixes-v2

Changes since V1:
 - squash of patches
 - picked up Ack from Keerthy
 - based on v3.11-rc3 tag

V1: http://marc.info/?t=137407980100008&r=1&w=2

Nishanth Menon (3):
  ARM: dts: omap5-uevm: document regulator signals used on the actual
    board
  ARM: dts: omap5-uevm: fix regulator configurations mandatory for SoC
  ARM: dts: omap5-uevm: update optional/unused regulator configurations

 arch/arm/boot/dts/omap5-uevm.dts |   78 ++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 29 deletions(-)

Regards,
Nishanth Menon
-- 
1.7.9.5

