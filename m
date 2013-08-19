Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3HSBaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:30:10 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50129 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab3HSBaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:30:08 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 0/2] mfd: 88pm8xx: platform data bug fix
Date: Sun, 18 Aug 2013 21:27:53 -0400
Message-ID: <1376875675-11286-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches fix the bug that pdata may be NULL when driver uses it.

Chao Xie (2):
  mfd: 88pm800: Fix the bug that pdata may be NULL
  mfd: 88pm805: Fix the bug that pdata may be NULL

 drivers/mfd/88pm800.c |   10 ++++++----
 drivers/mfd/88pm805.c |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.7.4.1

