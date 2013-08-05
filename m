Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3HEJ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:58:46 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34891 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab3HEJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:58:44 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com,
        ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Staging: winbond: Fixed some coding style issues
Date: Mon,  5 Aug 2013 11:58:26 +0200
Message-Id: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some coding style issues from drivers/staging/winbond

Iker Pedrosa (6):
  Staging: winbond: wb35reg: changed sleep function from msleep to
    usleep
  Staging: winbond: wb35reg: white space deleted
  Staging: winbond: wb35reg: avoided use of extern function
  Staging: winbond: mds: fixed some lines over 80 characters
  Staging: winbond: mds_f: fixed lines over 80 characters
  Staging: winbond: mds_f: deleted extern function

 drivers/staging/winbond/mds.c             | 56 ++++++++++++++++++-------------
 drivers/staging/winbond/mds_f.h           | 13 ++++---
 drivers/staging/winbond/phy_calibration.h |  1 +
 drivers/staging/winbond/wb35reg.c         | 13 ++++---
 4 files changed, 48 insertions(+), 35 deletions(-)

-- 
1.8.1.2

