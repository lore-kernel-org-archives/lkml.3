Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaHKPhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:37:43 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:57670 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbaHKPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:37:42 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] pinctrl: imx*: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:04:26 +0530
Message-Id: <1407771277-19477-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiran Padwal (11):
  pinctrl: imx23: Make of_device_id array const
  pinctrl: imx25: Make of_device_id array const
  pinctrl: imx27: Make of_device_id array const
  pinctrl: imx28: Make of_device_id array const
  pinctrl: imx35: Make of_device_id array const
  pinctrl: imx50: Make of_device_id array const
  pinctrl: imx51: Make of_device_id array const
  pinctrl: imx53: Make of_device_id array const
  pinctrl: imx6dl: Make of_device_id array const
  pinctrl: imx6q: Make of_device_id array const
  pinctrl: imx6sx: Make of_device_id array const

 drivers/pinctrl/pinctrl-imx23.c  |    2 +-
 drivers/pinctrl/pinctrl-imx25.c  |    2 +-
 drivers/pinctrl/pinctrl-imx27.c  |    2 +-
 drivers/pinctrl/pinctrl-imx28.c  |    2 +-
 drivers/pinctrl/pinctrl-imx35.c  |    2 +-
 drivers/pinctrl/pinctrl-imx50.c  |    2 +-
 drivers/pinctrl/pinctrl-imx51.c  |    2 +-
 drivers/pinctrl/pinctrl-imx53.c  |    2 +-
 drivers/pinctrl/pinctrl-imx6dl.c |    2 +-
 drivers/pinctrl/pinctrl-imx6q.c  |    2 +-
 drivers/pinctrl/pinctrl-imx6sx.c |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.7.9.5

