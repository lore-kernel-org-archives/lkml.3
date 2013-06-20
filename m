Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3FTPAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:00:44 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.111]:43945 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757701Ab3FTPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:00:43 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2013 11:00:42 EDT
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-11.tower-193.messagelabs.com!1371740051!14778750!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201306201454.r5KEs9av010969@swsrvapps-01.diasemi.com>
From: Steve Twiss <stwiss.opensource@diasemi.com>
Date: Thu, 20 Jun 2013 14:42:04 +0100
Subject: [RFC V1]  DA9210 driver request for comments
To: LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

The following describes the driver DA9210 from Dialog Semiconductor Ltd.

This is a request for comment relating to the Dialog DA9210 driver.
The patches have been made relative to the following kernel version:

linux-next next-20130620

This driver is for the Dialog DA9210 Multi-phase 12A DC-DC Buck
Converter controlled only from an I2C bus. It consists of a I2C device
driver which controls a synchronous 12 Amp step down converter. In this
case, the regulator component contains all parts of the driver in a
single file.

It would be appreciated if you could add any comments you may have about
the driver.

Thank you,
Steve Twiss, Dialog Semiconductor Ltd.

S Twiss (1):
  COMMIT 1: DA9210 driver files

 drivers/regulator/Kconfig                  |    7 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/da9210-regulator.c       |  334 ++++++++++++++++++++++++++++
 include/linux/regulator/da9210-regulator.h |  286 ++++++++++++++++++++++++
 4 files changed, 628 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/da9210-regulator.c
 create mode 100644 include/linux/regulator/da9210-regulator.h

-- 
end-of-patch for RFC V1

