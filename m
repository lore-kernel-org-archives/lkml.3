Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaETFEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:04:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37423 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaETFEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:04:33 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, dan.carpenter@oracle.com,
        David Matlack <matlackdavid@gmail.com>
Subject: [PATCH V2 0/2] staging: slicoss: fix checksum computation
Date: Mon, 19 May 2014 22:03:58 -0700
Message-Id: <1400562240-15159-1-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a broken checksum function and removes a struct
that was being used to ignore bad checksum values.

V2 Changes:
  * Change subject to make clear this patchset fixes a bug.
  * Explicitly comment that the checksum algorithm is RFC 1071.
  * Remove byte swapping code.
  * Add detail in the changelog of each patch describing the effects
    on the user.

David Matlack (2):
  staging: slicoss: fix eeprom checksum code
  staging: slicoss: fail on corrupt eeprom

 drivers/staging/slicoss/slic.h    |   7 ---
 drivers/staging/slicoss/slicoss.c | 113 ++++++--------------------------------
 2 files changed, 16 insertions(+), 104 deletions(-)

-- 
1.9.2

