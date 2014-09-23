Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaIWRip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:38:45 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52423 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaIWRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:38:43 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.17-rc7
Date: Tue, 23 Sep 2014 10:38:36 -0700
Message-Id: <1411493916-23435-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon fixes for Linux 3.17-rc7 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 4e66cd13ff9cd7eaae69e2fae0335d8d99d8afdf:

  hwmon: (tmp103) Fix resource leak bug in tmp103 temperature sensor driver (2014-09-22 11:11:48 -0700)

----------------------------------------------------------------
Fix a resource leak in tmp103 driver.
Add support for two more processors to fam15h_power driver.
Also fix a bug in the same driver to only report the power level
on chips which actually support reporting it.

----------------------------------------------------------------
Aravind Gopalakrishnan (2):
      hwmon: (fam15h_power) Make actual power reporting conditional
      hwmon: (fam15h_power) Add support for two more processors

sundarjdev (1):
      hwmon: (tmp103) Fix resource leak bug in tmp103 temperature sensor driver

 drivers/hwmon/fam15h_power.c | 20 +++++++++++++++++++-
 drivers/hwmon/tmp103.c       |  2 +-
 2 files changed, 20 insertions(+), 2 deletions(-)
