Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3FTHZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:25:13 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:40087 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3FTHZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:25:11 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 0/2] pinctrl: ABX500: fix
Date: Thu, 20 Jun 2013 09:24:42 +0200
Message-Id: <1371713084-19098-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Patrice Chotard (2):
  pinctrl: abx500: suppress hardcoded value
  pinctrl: abx500: fix abx500_gpio_get()

 drivers/pinctrl/pinctrl-abx500.c       |   34 ++++++++++++++++++++++++++------
 include/linux/mfd/abx500/ab8500-gpio.h |    5 +++++
 2 files changed, 33 insertions(+), 6 deletions(-)

-- 
1.7.10

