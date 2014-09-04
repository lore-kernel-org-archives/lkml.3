Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaIDPMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:12:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44188 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaIDPMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:12:45 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.17-rc4
Date: Thu,  4 Sep 2014 08:12:41 -0700
Message-Id: <1409843561-9245-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon fixes for Linux 3.17-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 39c627a084475e8a690a4a9e7601410ca173ddd2:

  hwmon: (ds1621) Update zbits after conversion rate change (2014-08-28 11:18:47 -0700)

----------------------------------------------------------------
Fix a bug in the ds1621 driver

----------------------------------------------------------------
Robert Coulson (1):
      hwmon: (ds1621) Update zbits after conversion rate change

 drivers/hwmon/ds1621.c | 1 +
 1 file changed, 1 insertion(+)
