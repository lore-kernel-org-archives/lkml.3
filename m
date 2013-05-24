Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3EXMHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:07:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54310 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3EXMHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:07:09 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 0/3] pinctrl: abx500: Fix pull up/down feature
Date: Fri, 24 May 2013 14:06:28 +0200
Message-Id: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

This series fixes the pull up/down feature of ABx500 family ASIC.

Patrice Chotard (3):
  pinctrl: abx500: fix abx500_config_pull_updown
  pinctrl: abx500: allow to set pull up
  pinctrl: abx500: fix abx500_gpio_dbg_show_one() to show pull up/down

 drivers/pinctrl/pinctrl-abx500.c |  110 ++++++++++++++++++++++++++++++++------
 1 file changed, 93 insertions(+), 17 deletions(-)

-- 
1.7.10

