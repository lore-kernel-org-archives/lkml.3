Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbaEKGPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 02:15:30 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34273 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaEKGP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 02:15:28 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v3 0/5] drivers: staging: ft1000: Improve coding style
Date: Sun, 11 May 2014 21:14:25 +0300
Message-Id: <1399832070-15276-1-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joe,

I've made the changes you requested. Each fix is now made in a separate patch.

This patch set fixes the ft1000 header files only. The inclusion of one .c file
(ft1000_debug.c) is caused by typedef removal.

Patch set includes:
  - Indentation fixes;
  - Fixes of IOCTL_FT1000_* marcos;
  - Using pr_info instead of printk;
  - Removal of typedefs;
  - Fix of lines over 80 characters.

This patch set version (#3) also fixes IOCTL_FT1000_ which become broken after
applying patch 4/5 (in patch set v2).

Thanks,
-Artem
