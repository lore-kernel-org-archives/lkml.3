Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaJPHXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:23:33 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:41103 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbaJPHXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:23:31 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-3.tower-178.messagelabs.com!1413444199!30999515!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 16 Oct 2014 09:23:19 +0200
Date: Thu, 16 Oct 2014 10:14:48 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <wsa@the-dreams.de>,
        <linux-i2c@vger.kernel.org>, <johannes.thumshirn@men.de>,
        <andreas.werner@men.de>
Subject: [PATCH 0/2] Introduce MEN Board Information EEPROM driver
Message-ID: <cover.1413416105.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the MEN Board Information EEPROM.

The EEPROM is assembled on almost all of the MEN hardware boards and is the
main location to get information about the board.

The driver exports the EEPROM data like production date, board name and serial number
as read-only files as well as a user section for read-write access.

There is also a ABI documentation for sysfs description included.

Andreas Werner (2):
  drivers/misc/eeprom/men_eeprod: Introduce MEN Board Information EEPROM
    driver
  Documentation/ABI/testing/men_eeprod: Added sysfs description for
    men_eeprod

 .../ABI/testing/sysfs-bus-i2c-devices-men_eeprod   |  69 +++
 MAINTAINERS                                        |   6 +
 drivers/misc/eeprom/Kconfig                        |  10 +
 drivers/misc/eeprom/Makefile                       |   1 +
 drivers/misc/eeprom/men_eeprod.c                   | 560 +++++++++++++++++++++
 5 files changed, 646 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod
 create mode 100644 drivers/misc/eeprom/men_eeprod.c

-- 
2.1.0

