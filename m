Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaHHHbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:31:52 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:38067 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHHbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:31:50 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <da3ac7e74bfcfddafae3296746efed4b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: thierry.reding@gmail.com, heiko@sntech.de, b.galvani@gmail.com,
        robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, dianders@chromium.org
Cc: cf@rock-chips.com, addy.ke@rock-chips.com, cjf@rock-chips.com,
        xjq@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v5 0/2] This series adds support for RK3288 SoC integrated PWM
Date: Fri,  8 Aug 2014 15:28:47 +0800
Message-Id: <1407482929-13050-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Changes in v5:
    * address comments from Thierry Reding and Doug Anderson:
    - fix the symbolic names for registers. 

Changes in v4:
    * address comments from Heiko Stübner:
    - fix the copyright for ROCKCHIP, Inc. 
    - remove rockchip_pwm_set_enable_vop,then it instead of rockchip_pwm_set_enable_v2.

Changes in v3:
    * address comments from Thierry Reding:
    - fix PWM document deccribes. 
    - add a description for [PATCH v3 2/2].
    - renamed the PWM registers
    - Changed in rockchip_pwm_data struct
    - remove the devm_ioremap(),fixed in lcdc driver.

Changes in v2:
    * address comments from Beniamino Galvani:
    - remove #include <linux/of_address.h>. 
    - of_iomap be removed,and devm_ioremap replace it.
    - remove a line no be used.

Caesar Wang (2):
  pwm: rockchip: document RK3288 SoC compatible
  pwm: rockchip: Added to support for RK3288 SoC

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |   5 +-
 drivers/pwm/pwm-rockchip.c                         | 134 +++++++++++++++++----
 2 files changed, 114 insertions(+), 25 deletions(-)

-- 
1.9.1


