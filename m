Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaGQGJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:09:01 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:34716 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaGQGI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:08:57 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <e0d148f19b24f1be5209f496890b1b73>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: caesar <caesar.wang@rock-chips.com>
To: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org
Cc: linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cf@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, hj@rock-chips.com,
        caesar <caesar.wang@rock-chips.com>
Subject: [PATCH 0/2] This series adds support for Rockchip SoCs integrated PWM.
Date: Thu, 17 Jul 2014 14:08:12 +0800
Message-Id: <1405577294-19336-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch would be make applying on the top of Beniamino's submission,
the Beniamino's submission come from [1].
[1]:
https://git.kernel.org/cgit/linux/kernel/git/thierry.reding/linux-pwm.git/log/?h=for-next

Beniamino's submission won't be used from next genenation RK SoCs.
So we have to add support to the new pwm version and VOP_PWM for next genenation RK SoCs.

Tested on RK3288 SDK board.

caesar (2):
 [PATCH 1/2] pwm: add this series patch to introduce for rk-pwm and vop-pwm
 [PATCH 2/2] pwm: add this series patch to support for rk-pwm and vop-pwm.

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  13 ++-
 drivers/pwm/pwm-rockchip.c                         | 108 +++++++++++++++++----
 2 files changed, 96 insertions(+), 25 deletions(-)

-- 
1.9.1
mZ

