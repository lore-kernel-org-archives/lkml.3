Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161714Ab3BOM52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:28 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62487 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3BOM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:22 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 00/35] mfd: ab8500: Internal development push
Date: Fri, 15 Feb 2013 12:56:31 +0000
Message-Id: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

This is the patch-set we've been speaking about. It's the entire
development history for the ABx500 related MFD changes from
ST-Ericsson's internal kernel. This brings us bang up-to-date.

Please don't apply patches directly from this submission, as
there are some interdependencies which we need to sort out
between you, Anton and I.

Enjoy! =:-)


 drivers/mfd/ab8500-core.c                 |  524 +++++++++++++++++++-------
 drivers/mfd/ab8500-debugfs.c              | 2511 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/mfd/ab8500-gpadc.c                |  577 +++++++++++++++++++++++------
 drivers/mfd/ab8500-sysctrl.c              |   98 ++++-
 include/linux/mfd/abx500.h                |    2 -
 include/linux/mfd/abx500/ab8500-gpadc.h   |   74 +++-
 include/linux/mfd/abx500/ab8500-sysctrl.h |    6 +
 include/linux/mfd/abx500/ab8500.h         |  242 +++++++++---
 8 files changed, 3177 insertions(+), 857 deletions(-)

