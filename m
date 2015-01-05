Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbbAEKLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:11:22 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42370 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbbAEKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:11:21 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Subject: [RESEND PATCH 0/2] pinctrl-st: various fixes 
Date: Mon,  5 Jan 2015 11:04:12 +0100
Message-Id: <1420452254-30625-1-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-05_01:2015-01-05,2015-01-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend this series, it seems that the one i send in 
December has been lost despite it was visible on lkml

Two fixes for pinctrl-st pinctrl driver

Francesco VIRLINZI (1):
  pinctrl: st: avoid multiple mutex lock

Patrice Chotard (1):
  pinctrl: st: Add irq_disable hook to st_gpio_irqchip

 drivers/pinctrl/pinctrl-st.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
1.9.1

