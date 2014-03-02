Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaCBFXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 00:23:03 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41599 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaCBFXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 00:23:01 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 0/9] drivers: staging: rtl8187se: various code cleanups
Date: Sat,  1 Mar 2014 22:22:44 -0700
Message-Id: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches fixes a substantial number of checkpatch.pl errors and warnings, and additionally it refactors some sections of code where lines were far too long due to organizational problems.

Axel Rasmussen (9):
  drivers: staging: rtl8187se: use netdev_* instead of prink
  drivers: staging: rtl8187se: refactor/clean signal smoothing
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: fixed broken indentation
  drivers: staging: rtl8187se: fixed checkpatch.pl errors
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: refactor wmm_param_update

 drivers/staging/rtl8187se/Module.symvers |   0
 drivers/staging/rtl8187se/r8180.h        |   2 +-
 drivers/staging/rtl8187se/r8180_core.c   | 641 ++++++++++++++++++-------------
 3 files changed, 375 insertions(+), 268 deletions(-)
 create mode 100644 drivers/staging/rtl8187se/Module.symvers

-- 
1.8.3.2

