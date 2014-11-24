Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaKXP6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:58:45 -0500
Received: from hosting.pavoucek.net ([46.28.107.168]:60866 "EHLO
	hosting.pavoucek.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaKXP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:58:43 -0500
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 10:58:43 EST
From: Tomas Novotny <tomas@novotny.cz>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>
Subject: [PATCH 0/4] rtc: ds1307: add support for device tree and mcp7940x
Date: Mon, 24 Nov 2014 16:49:20 +0100
Message-Id: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is tested with MCP79401 and it is based on 3.18-rc6.

Tomas Novotny (4):
  rtc: ds1307: add support for mcp7940x chips
  of: add vendor prefix for Pericom Technology
  rtc: ds1307: add device tree bindings documentation
  rtc: ds1307: add device tree support

 .../devicetree/bindings/rtc/maxim,ds1307.txt       |  23 ++++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/rtc/rtc-ds1307.c                           | 149 ++++++++++++---------
 3 files changed, 110 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/maxim,ds1307.txt

-- 
2.1.2

