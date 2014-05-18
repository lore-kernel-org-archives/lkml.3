Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaEREAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 00:00:11 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57852 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaEREAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 00:00:10 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH 0/2] staging: slicoss: cleanup checksum computation
Date: Sat, 17 May 2014 21:00:02 -0700
Message-Id: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a broken checksum function and removes a struct
that was being used to ignore bad checksum values.

David Matlack (2):
  staging: slicoss: rewrite eeprom checksum code
  staging: slicoss: remove slic_reg_params struct

 drivers/staging/slicoss/slic.h    |   7 --
 drivers/staging/slicoss/slicoss.c | 140 +++++++++++++-------------------------
 2 files changed, 47 insertions(+), 100 deletions(-)

-- 
1.9.2

