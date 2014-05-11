Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbaEJTzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:55:33 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60236 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaEJTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:55:32 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v2 0/5] drivers: staging: ft1000: Improve coding style
Date: Sun, 11 May 2014 10:54:19 +0300
Message-Id: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
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

Thanks,
-Artem
