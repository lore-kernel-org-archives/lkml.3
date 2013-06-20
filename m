Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639Ab3FTOGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:06:12 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39109 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093Ab3FTOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:06:09 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH v2 0/4] pinctrl: ABX500: fix
Date: Thu, 20 Jun 2013 16:05:41 +0200
Message-Id: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Patrice Chotard (4):
  pinctrl: abx500: suppress hardcoded value
  pinctrl: abx500: fix abx500_gpio_get()
  pinctrl: abx500: factorize code
  pinctrl: abx500: rework error path

 drivers/pinctrl/pinctrl-abx500.c       |  173 +++++++++++++++++++++++---------
 include/linux/mfd/abx500/ab8500-gpio.h |    5 +
 2 files changed, 132 insertions(+), 46 deletions(-)

-- 
1.7.10

