Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbaGSM4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 08:56:14 -0400
Received: from regular2.263xmail.com ([211.157.152.4]:36902 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaGSM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 08:56:09 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <8c6a4074e1201c16c22c9aeb6cf645b8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, thierry.reding@gmail.com, b.galvani@gmail.com
Cc: cf@rock-chips.com, huangtao@rock-chips.com, addy.ke@rock-chips.com,
        xjq@rock-chips.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v2 0/2] This series adds support for Rockchip SoCs integrated PWM.
Date: Sat, 19 Jul 2014 20:55:27 +0800
Message-Id: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will make applying on the top of Beniamino's submission,
the Beniamino's submission come from [1].

[1]:
https://git.kernel.org/cgit/linux/kernel/git/thierry.reding/linux-pwm.git/log/?h=for-next

Beniamino's submission won't be used from genenation Rockchip SoCs.
So I have to add the new pwm for next genenation Rockchip SoCs.

Tested on RK3288 SDK board.

Changes in v2:
    * address comments from Beniamino Galvani Reding:
      - remove #include <linux/of_address.h>. 
      - of_iomap be removed,and devm_ioremap replace it.
      - remove a line no be used.

Caesar Wang (2):
  [PATCH v2 1/2] pwm: add this patch to introduce for rk-pwm and vop-pwm

  [PATCH v2 2/2] pwm: add this patch to support the new pwm of Rockchip SoCs

 .../devicetree/bindings/pwm/pwm-rockchip.txt       | 13 +--
 drivers/pwm/pwm-rockchip.c                         | 97 ++++++++++++++++++----
 2 files changed, 87 insertions(+), 23 deletions(-)

-- 
1.9.1


