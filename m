Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3IPNoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:44:00 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46774 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3IPNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:43:59 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/24] Staging: winbond: Fixed some coding style issues
Date: Mon, 16 Sep 2013 15:43:20 +0200
Message-Id: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some coding style issues from drivers/staging/winbond

Iker Pedrosa (24):
  Staging: winbond: mto: removed function declaration
  Staging: winbond: mto: avoided use of extern functions
  Staging: winbond: mto: deleted extern functions
  Staging: winbond: phy_calibration: first of the patches that fixes
    lines over 80 characters
  Staging: winbond: phy_calibration: second of the patches that fixes
    lines over 80 characters
  Staging: winbond: reg: erased trailing whitespace
  Staging: winbond: reg: white space deleted
  Staging: winbond: reg: changed sleep function from msleep to usleep
  Staging: winbond: reg: first of the patches that fixes lines over 80
    characters
  Staging: winbond: reg: second of the patches that fixes lines over 80
    characters
  Staging: winbond: reg: third of the patches that fixes lines over 80
    characters
  Staging: winbond: reg: fourth of the patches that fixes lines over 80
    characters
  Staging: winbond: reg: fifth of the patches that fixes lines over 80
    characters
  Staging: winbond: reg: sixth of the patches that fixes lines over 80
    characters
  Staging: winbond: reg: seventh of the patches that fixes lines over 80
    characters
  Staging: winbond: wb35reg_f: fixed lines over 80 characters
  Staging: winbond: wb35reg_s: deleted space before tabulation
  Staging: winbond: wb35rx: changed sleep function from msleep to usleep
  Staging: winbond: wb35rx: fixed some lines over 80 characters
  Staging: winbond: wb35tx: changed sleep function from msleep to usleep
  Staging: winbond: wb35tx: Replace printk with netdev_err
  Staging: winbond: wb35tx_s: erased the spaces after opening a '['
  Staging: winbond: wbusb: fixed some lines over 80 characters
  Staging: winbond: wbusb: changed sleep function from msleep to usleep

 drivers/staging/winbond/mto.c             |   7 +-
 drivers/staging/winbond/mto.h             |   8 +-
 drivers/staging/winbond/phy_calibration.c |  58 ++++---
 drivers/staging/winbond/reg.c             | 272 ++++++++++++++++++------------
 drivers/staging/winbond/wb35reg_f.h       |  18 +-
 drivers/staging/winbond/wb35reg_s.h       |   2 +-
 drivers/staging/winbond/wb35rx.c          |  11 +-
 drivers/staging/winbond/wb35tx.c          |  12 +-
 drivers/staging/winbond/wb35tx_s.h        |   2 +-
 drivers/staging/winbond/wbusb.c           |  18 +-
 10 files changed, 239 insertions(+), 169 deletions(-)

-- 
1.8.1.2

