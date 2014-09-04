Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaIDQkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:40:16 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60416 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbaIDQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:40:14 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org, torvalds@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL resend] hwmon fixes for 3.17-rc4
Date: Thu,  4 Sep 2014 09:40:03 -0700
Message-Id: <1409848803-17893-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know my e-mail service is acting up again, so I don't know if there
is a problem with linux-foundation.org or with my e-mail service or if I
should have used linuxfoundation.org all along. Either case, resending to
both torvalds@linuxfoundation.org and torvalds@linux-foundation.org
in the hope that one is received. Sorry for the noise.

---

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
