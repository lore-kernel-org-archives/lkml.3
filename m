Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaBOUWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:22:40 -0500
Received: from vm1.sequanux.org ([188.165.36.56]:39900 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaBOUWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:22:37 -0500
From: Simon Guinot <simon.guinot@sequanux.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH 0/2] Add alarm suport for the Microchip RTC devices MCP794xx
Date: Sat, 15 Feb 2014 21:15:21 +0100
Message-Id: <1392495323-22875-1-git-send-email-simon.guinot@sequanux.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds alarm support for the Microchip RTC devices
MCP794xx. A such compatible RTC (MCP7940NT) is embedded on the Seagate
boards n090x01 (based on the Armada-370 SoC).

Regards,

Simon

Simon Guinot (2):
  rtc: rtc-ds1307: fix sysfs wakealarm attribute creation
  rtc: rtc-ds1307: add alarm support for mcp7941x chips

 drivers/rtc/rtc-ds1307.c | 185 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 183 insertions(+), 2 deletions(-)

-- 
1.8.5.3

