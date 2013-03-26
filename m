Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab3CZJfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:35:23 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63708 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3CZJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:35:21 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 0/3] driver core: documentation and checkpatch complaints
Date: Tue, 26 Mar 2013 10:35:14 +0100
Message-Id: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
one patch is to improve documentation about deferred probing
and two patches are to fix checkpatch complaints.

Best regards

Fabio Porcedda (3):
  driver core: warn that platform_driver_probe can not use deferred
    probing
  driver core: platform.c: fix checkpatch errors and warnings
  driver core: platform_device.h: fix checkpatch errors and warnings

 drivers/base/platform.c         | 24 +++++++++++++-----------
 include/linux/platform_device.h | 24 ++++++++++++++----------
 2 files changed, 27 insertions(+), 21 deletions(-)

-- 
1.8.2

