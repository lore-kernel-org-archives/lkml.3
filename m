Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbbAVQCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:02:37 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:46224 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbbAVQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:02:35 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 172.245.48.25
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <6bfb44f665a9d7a000ed90ed0510b247>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Caesar Wang <wxt@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>, Caesar Wang <wxt@rock-chips.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 0/1] thermal: rockchip: make temperature reporting much more accurate
Date: Fri, 23 Jan 2015 00:01:27 +0800
Message-Id: <1421942488-13764-1-git-send-email-wxt@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is merged on chromiumos/third_party/kernel.
https://chromium-review.googlesource.com/#/c/239190/

Tested on veyron boards.


Changes in v4:
"return -EAGAIN" instead of "return rk_tsadcv2_code_to_temp(code)"

Changes in v3:
Suggested-by Daniel Kurtz,
the check doesn't reject "code == 0xfff"
Fixed in rk_tsadcv2_code_to_temp(u32 code)

Changes in v2:
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Caesar Wang (1):
  thermal: rockchip: make temperature reporting much more accurate

 drivers/thermal/rockchip_thermal.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

-- 
1.9.1


