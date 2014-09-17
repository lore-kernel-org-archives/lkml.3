Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaIQNIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:08:16 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60993 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaIQNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:08:14 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>, devicetree@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] regulator: get voltage & duty table from dts for st-pwm
Date: Wed, 17 Sep 2014 21:07:58 +0800
Message-Id: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get voltage & duty table from device tree might be better, other platforms can also use this
driver without any modify.
Tested on a rk3288 sdk board as logic voltage regulator.


Chris Zhong (2):
  regulator: st-pwm: get voltage and duty table from dts
  dt-bindings: add devicetree bindings for st-pwm regulator

 .../devicetree/bindings/regulator/st-pwm.txt       |   35 +++++++++
 drivers/regulator/Kconfig                          |    1 -
 drivers/regulator/st-pwm.c                         |   80 ++++++++++----------
 3 files changed, 77 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/st-pwm.txt

-- 
1.7.9.5

