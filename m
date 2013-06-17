Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3FQALk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:11:40 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62814 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab3FQALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:11:39 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 0/3] Staging: silicom: EXPORT_SYMBOL cleanup
Date: Sun, 16 Jun 2013 19:05:22 -0500
Message-Id: <1371427525-6007-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the EXPORT_SYMBOL calls in staging/silicom by
placing the exports immediately below the definitions they refer to
(as is the convention) and removing the no-longer-useful
EXPORT_SYMBOL_NOVERS macro.

Chad Williamson (3):
  Staging: silicom: move symbol exports beneath definitions in
    bpctl_mod.c
  Staging: silicom: move symbol exports beneath definitions in bypass.c
  Staging: silicom: remove the EXPORT_SYMBOL_NOVERS macro

 drivers/staging/silicom/bp_mod.h           |  2 -
 drivers/staging/silicom/bpctl_mod.c        | 91 +++++++++++++++---------------
 drivers/staging/silicom/bypasslib/bplibk.h |  2 -
 drivers/staging/silicom/bypasslib/bypass.c | 89 +++++++++++++++--------------
 4 files changed, 89 insertions(+), 95 deletions(-)

-- 
1.8.1.4

