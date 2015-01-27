Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbbA0PLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:11:46 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:51854 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbA0PLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:11:42 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <wim@iguana.be>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>,
        <paul@crapouillou.net>
Subject: [PATCH 0/2] watchdog: jz4740: Add DT support
Date: Tue, 27 Jan 2015 15:11:28 +0000
Message-ID: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two simple patches that add DT support to the jz4740 watchdog driver.

Patches are based on 3.19-rc6. Quite disjoint and stay within jz4740
so should apply easily on other trees.

If you would like to have them rebased to a different tree, please tell.

Thank-you

ZubairLK

Zubair Lutfullah Kakakhel (2):
  dt: watchdog: Add DT binding documentation for jz47xx watchdog timer
  watchdog: jz4740: Add DT support

 .../devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt | 17 +++++++++++++++++
 drivers/watchdog/jz4740_wdt.c                           |  9 +++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt

-- 
1.9.1

