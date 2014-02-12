Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaBLTe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:34:57 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60843 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaBLTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:34:56 -0500
Date: Wed, 12 Feb 2014 23:34:48 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git: fixes for v3.14
Message-ID: <20140212193448.GA6565@anuminas.rup.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Could you please pull battery-2.6.git tree containing several fixes
for v3.14 kernel.

The following changes since commit 573189354b7c97cd2256b87cf083ee435584594e:

  MAINTAINERS: Pick up power supply maintainership (2014-01-21 03:33:09 +0400)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.14-fixes

for you to fetch changes up to ac323d8d807060f7c95a685a9fe861e7b6300993:

  power: max17040: Fix NULL pointer dereference when there is no platform_data (2014-02-01 20:11:32 +0400)

----------------------------------------------------------------
Few fixes:

- Fix NULL pointer dereference in max17040 driver

- Add bq2415x dts bindings documentation

- Fix misleading comment in ds2782 driver

- Remove useless check in isp1704 charger driver.

----------------------------------------------------------------
Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platform_data

Matthias Brugger (1):
      power: ds2782_battery: Typo in comment

Sebastian Reichel (1):
      dt: binding documentation for bq2415x charger

Wei Yongjun (1):
      isp1704_charger: remove useless check in isp1704_charger_probe()

 .../devicetree/bindings/power/bq2415x.txt          | 47 ++++++++++++++++++++++
 drivers/power/ds2782_battery.c                     |  2 +-
 drivers/power/isp1704_charger.c                    |  2 -
 drivers/power/max17040_battery.c                   |  5 ++-
 4 files changed, 51 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/bq2415x.txt

-- 
With best wishes
Dmitry
