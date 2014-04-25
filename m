Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaDYJmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:42:04 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53722 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaDYJmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:42:01 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 0/3] Staging: lustre: Fixed sparse complaints
Date: Fri, 25 Apr 2014 11:41:40 +0200
Message-Id: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the following sparse complaints:
[1/3]: use of a plain integer as NULL pointer
[2/3]: symbols that should declared as static
[3/3]: use of an unsigned int as gfp_t

Fabio Falzoi (3):
  Staging: lustre: Avoid using 0 instead of NULL
  Staging: lustre: ops structs should be declared static
  Staging: lustre: gfp_mask should be of gfp_t type

 drivers/staging/lustre/lustre/include/lprocfs_status.h |  4 ++--
 drivers/staging/lustre/lustre/include/lustre_dlm.h     |  6 +++---
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h     |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c         | 16 ++++++++--------
 drivers/staging/lustre/lustre/llite/lproc_llite.c      |  6 +++---
 5 files changed, 17 insertions(+), 17 deletions(-)

-- 
1.9.1

