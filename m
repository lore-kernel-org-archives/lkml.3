Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbaJUUW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:22:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46419 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbaJUUWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:22:54 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] ARM: OMAP4+: PM: centralize static dependency mapping table
Date: Tue, 21 Oct 2014 15:22:27 -0500
Message-ID: <1413922949-22300-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a small step towards getting rid of static dependency logic
from mach-omap2. As part of this, we split the list of static dep
map from the function implementing it. This should eventually aid in
helping remove the tables from the kernel to the device tree at a
later point in time of cleanup.

Series based on v3.18-rc1 and could be a 3.19-rc1 material.

Nishanth Menon (2):
  ARM: OMAP4: PM: Only do static dependency configuration in
    omap4_init_static_deps
  ARM: OMAP4+: PM: Centralize static dependency mapping table

 arch/arm/mach-omap2/pm44xx.c |  146 +++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 80 deletions(-)

-- 
1.7.9.5

