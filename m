Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbaGWAfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:35:11 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:57512 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbaGWAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:35:10 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH v2 0/2] staging: cxt1e1: Fix ambiguous global var names, reduce sparse warnings 
Date: Tue, 22 Jul 2014 20:34:54 -0400
Message-Id: <1406075696-15912-1-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set:
changes ambiguous global names, such as "error_flag" to "cxt1e1_error_flag"
puts globals in header file to reduce externs used in c files as well as sparse warnings

Jeff Oczek (2):
  staging: cxt1e1: Prefix ambiguous variable names with 'cxt1e1_' for
    clarity
  staging: cxt1e1: Fix static symbol sparse warnings for global vars in
    linux.c

 drivers/staging/cxt1e1/cxt1e1_common.h | 14 +++++++++
 drivers/staging/cxt1e1/hwprobe.c       |  7 +++--
 drivers/staging/cxt1e1/linux.c         | 54 +++++++++++++++++++---------------
 drivers/staging/cxt1e1/musycc.c        |  5 +---
 drivers/staging/cxt1e1/pmcc4_drv.c     | 23 +++++++--------
 drivers/staging/cxt1e1/sbeproc.c       |  6 ++--
 6 files changed, 64 insertions(+), 45 deletions(-)
 create mode 100644 drivers/staging/cxt1e1/cxt1e1_common.h

-- 
1.9.1

