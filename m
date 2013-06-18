Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3FRDc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:32:26 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33288 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3FRDcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:32:25 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 0/4] Staging: silicom: coding style cleanup
Date: Mon, 17 Jun 2013 22:32:01 -0500
Message-Id: <1371526325-9821-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More coding style cleanup in bpctl_mod.c, resolving many checkpatch.pl
warnings and errors. I've skipped a number of issues in functions that
are going to need to be split up/rewritten anyway, etc. Tearing out the
new typedefs is next on my todo list...

Chad Williamson (4):
  Staging: silicom: remove unnecessary braces in bpctl_mod.c
  Staging: silicom: whitespace fixes in bpctl_mod.c
  Staging: silicom: move assignments out of if conditions
  Staging: silicom: move more assignments out of if conditions

 drivers/staging/silicom/bpctl_mod.c | 171 ++++++++++++++++++++----------------
 1 file changed, 94 insertions(+), 77 deletions(-)

-- 
1.8.1.4

