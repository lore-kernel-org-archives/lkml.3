Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaLVB12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:27:28 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58779 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbaLVB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:25 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] dgnc: patches that fix checkpatch issues
Date: Mon, 22 Dec 2014 02:17:28 +0100
Message-Id: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We fixed some coding style issues in staging/dgnc.
Mostly it fixes lines over 80 characters (dgnc_neo.c, dgnc_cls.h, dgnc_compact.h,
dgnc_driver.h)
In dgnc_sysfs.c we replaced printk by pr_err.
In dpacompat.h we also set complex macros into enclosed parantheses 

Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>


Simone Weiss (6):
  dgnc/dgnc_cls.h: checkpatch: fixed long lines by moving comments
  dgnc/dgnc_sysfc.c: checkpatch: Use of pr_err insted of printk
  dgnc/dpacompat.h: checkpatch: fixed long lines by moving comments
  dgnc/dpacompat.h: checkpatch: Changend complex Macros (enclosed
    parantheses)
  dgnc/dgnc_neo.c: checkpatch: fixed long lines
  dgnc/dgnc_driver.h: checkpatch: fixed lines  over 80 characters

 drivers/staging/dgnc/dgnc_cls.h    |  13 ++-
 drivers/staging/dgnc/dgnc_driver.h |  71 +++++++-----
 drivers/staging/dgnc/dgnc_neo.c    | 214 ++++++++++++++++++++++++++-----------
 drivers/staging/dgnc/dgnc_sysfs.c  |   4 +-
 drivers/staging/dgnc/dpacompat.h   |  15 +--
 5 files changed, 212 insertions(+), 105 deletions(-)

-- 
1.9.1

