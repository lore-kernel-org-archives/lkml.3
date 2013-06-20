Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3FTHYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:24:02 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54376 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3FTHYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:24:00 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 0/2] pinctrl: ABX500: Add device tree support 
Date: Thu, 20 Jun 2013 09:23:20 +0200
Message-Id: <1371713002-18974-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

This patchset replaces previously submitted patch regarding device tree
support for ABX500 Asic family. It now uses pin configuration generic 
parsing code proposed by Heiko Stuebner.

Patrice Chotard (2):
  pinctrl: abx500: Add device tree support
  pinctrl: abx500: fix abx500_pin_config_set()

 .../devicetree/bindings/pinctrl/ste,abx500.txt     |  352 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-abx500.c                   |  215 +++++++++++-
 2 files changed, 561 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,abx500.txt

-- 
1.7.10

