Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaLIIf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:35:28 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48600 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaLIIf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:35:27 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/2] various fixes for pinctrl-st
Date: Tue,  9 Dec 2014 09:35:13 +0100
Message-Id: <1418114115-26064-1-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-09_03:2014-12-08,2014-12-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix deadlock when using debugfs pinconf-pins entry
Add missing hook .irq_disable

Francesco VIRLINZI (1):
  pinctrl: st: avoid multiple mutex lock

Pankaj Dev (1):
  pinctrl: st: Add irq_disable hook to st_gpio_irqchip

 drivers/pinctrl/pinctrl-st.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
1.9.1

