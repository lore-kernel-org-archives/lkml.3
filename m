Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3JUD1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:27:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43472 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3JUD1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:27:11 -0400
From: Benson Leung <bleung@chromium.org>
To: wsa@the-dreams.de, mika.westerberg@linux.intel.com, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dlaurie@chromium.org, bleung@chromium.org
Subject: [PATCH 0/2] i2c-designware-pci: Add Haswell ULT device support
Date: Sun, 20 Oct 2013 20:26:48 -0700
Message-Id: <1382326010-4554-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Haswell ULT device IDs for i2c-designware-pci. These are used,
for example, in Haswell generation Chromebooks, the HP Chromebook 14
and the Acer C720.

[PATCH 1/2] i2c-designware-pci: Add Haswell ULT device IDs
[PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0

