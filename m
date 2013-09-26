Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3IZNLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:11:15 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11509 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3IZNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:11:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Sep 2013 06:07:34 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] mfd: palmas: fix the resource leak issue and cleanups.
Date: Thu, 26 Sep 2013 19:03:47 +0530
Message-ID: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does the:
- removing non-require api calls.
- Fix the resource leaks.
- reset the initialisation done in probing.

Laxman Dewangan (4):
  mfd: palmas: remove call of mfd_remove_devices
  mfd: palmas: add MODULE_DEVICE_TABLE for of_device table
  mfd: palmas: reset pm_power_off if it is set for the device
  mfd: palmas: fix resource leak of i2c_dummy devices

 drivers/mfd/palmas.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

