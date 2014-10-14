Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaJNOlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:41:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54831 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaJNOlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:41:45 -0400
From: George Cherian <george.cherian@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <Baohua.Song@csr.com>, <rongjun.ying@csr.com>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/2] Add dt support for extcon gpio driver
Date: Tue, 14 Oct 2014 20:09:03 +0530
Message-ID: <1413297545-26521-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series
        - Adds dt support to extcon-gpio driver.
	- Add cable name support in case of dt.

George Cherian (2):
  extcon: gpio: Add dt support for the driver
  extcon: gpio: Add support for using cable names

 drivers/extcon/extcon-gpio.c       | 87 +++++++++++++-------------------------
 include/linux/extcon/extcon-gpio.h | 59 --------------------------
 2 files changed, 29 insertions(+), 117 deletions(-)
 delete mode 100644 include/linux/extcon/extcon-gpio.h

-- 
1.8.3.1

