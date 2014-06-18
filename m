Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaFRORs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:17:48 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:42750 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756732AbaFRORo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:17:44 -0400
From: Christian Bay <christian.bay@studium.fau.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lisa@xenapiadmin.com, linux-kernel@i4.cs.fau.de,
        Christian Bay <christian.bay@studium.fau.de>
Subject: [PATCH 0/2] Staging: bcm: checkpath.pl fixes
Date: Wed, 18 Jun 2014 16:10:04 +0200
Message-Id: <1403100606-14881-1-git-send-email-christian.bay@studium.fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series will fix several errors and warnings
shown by the checkpath.pl script at module
driver/staging/bcm.

Kernel Version: v3.16-rc1

Christian Bay (2):
  Staging: bcm: Prototypes.h: fix checkpatch errors
  Staging: bcm: Queue.h: fix checkpatch errors

 drivers/staging/bcm/Prototypes.h | 89 +++++++++++++++++++---------------------
 drivers/staging/bcm/Queue.h      | 44 ++++++++++----------
 2 files changed, 63 insertions(+), 70 deletions(-)


-- 
1.9.1

