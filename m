Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbbARX4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 18:56:23 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:52731 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbARX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 18:56:21 -0500
X-Greylist: delayed 27566 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2015 18:56:21 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 173.208.56.148
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <cde4ee0a1221de94e997552814415190>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 5
From: Caesar Wang <wxt@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Caesar Wang <wxt@rock-chips.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/1] thermal: rockchip: make temperature reporting much more accurate
Date: Mon, 19 Jan 2015 07:55:48 +0800
Message-Id: <1421625349-14101-1-git-send-email-wxt@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is merged on chromiumos/third_party/kernel.
https://chromium-review.googlesource.com/#/c/239190/

Tested on veyron boards.


Changes in v2:
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Caesar Wang (1):
  thermal: rockchip: make temperature reporting much more accurate

 drivers/thermal/rockchip_thermal.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

-- 
1.9.1


