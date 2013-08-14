Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab3HNI3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:29:09 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44064 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab3HNI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:29:06 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 0/4] mfd: 88pn80x: bug fix and device tree support
Date: Wed, 14 Aug 2013 04:28:46 -0400
Message-ID: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 4 patches.
1. Bug fix.
  mfd: 88pm800: Fix the bug that pdata may be NULL
  mfd: 88pm805: Fix the bug that pdata may be NULL
  Above patches fix the bug that pdata may be NULL when driver uses it.

2. Device tree support
  mfd: 88pm800: add device tree support
  mfd: 88pm805: add device tree support
  Add device tree support for 88pm800 and 88pm805

Chao Xie (4):
  mfd: 88pm800: Fix the bug that pdata may be NULL
  mfd: 88pm805: Fix the bug that pdata may be NULL
  mfd: 88pm800: add device tree support
  mfd: 88pm805: add device tree support

 Documentation/devicetree/bindings/mfd/88pm800.c |   55 +++++++++++++++++++
 Documentation/devicetree/bindings/mfd/88pm805.c |   15 +++++
 drivers/mfd/88pm800.c                           |   65 +++++++++++++++++++++--
 drivers/mfd/88pm805.c                           |   10 +++-
 4 files changed, 140 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/88pm800.c
 create mode 100644 Documentation/devicetree/bindings/mfd/88pm805.c

-- 
1.7.4.1

