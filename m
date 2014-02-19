Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaBSQhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:37:12 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:8665 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501AbaBSQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:37:09 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-11.tower-178.messagelabs.com!1392827826!27197945!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402191636.s1JGakB1017627@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Wed, 19 Feb 2014 16:32:47 +0000
Subject: [PATCH V1 0/3] da9052: Add new supported chip
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: David Jander <david@protonic.nl>, <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is submission attempt number 1 to have this patch sequence applied
to the linux kernel source tree.

The DA9052 and DA9053 are low power Power Management Integrated Circuits
with extra functionality beyond the power regulators.

There is now a new variant of the DA9053 PMIC called BC, and this
patch sequence provides for it's support.

There is one difference between it and the AA, BA and BB variants.

There is also the correctiion of a typing mistake in one of the BA
name strings that was erroneously typed as "ab".

This patch sequence depends on the first being applied first because
it provides the hash definition of DA9053_BC

Many thanks,

Anthony Olech, Dialog Semiconductor

Opensource [Anthony Olech] (3):
  include/linux/mfd/da9052/da9052: Add new BC chip
  MFD: da9052: Add new DA9053 BC chip variant
  REGULATOR: da9052: Add new DA9053 BC chip variant

 drivers/mfd/da9052-i2c.c             |    5 ++++-
 drivers/mfd/da9052-spi.c             |    1 +
 drivers/regulator/da9052-regulator.c |    1 +
 include/linux/mfd/da9052/da9052.h    |    1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

-- 
end-of-patch 0/3 for PATCH V1

