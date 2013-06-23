Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab3FWHDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:03:39 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63147 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3FWHDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:03:36 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 0/6] Staging: silicom: Remove all typedefs from bpctl_mod.c
Date: Sun, 23 Jun 2013 02:02:22 -0500
Message-Id: <1371970948-26802-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More coding style cleanup on bpctl_mod.c in the form of a few typedef
exorcisms, one of which is a little long (let me know if you'd like
me to split it up into multiple patches...).

Chad Williamson (6):
  Staging: silicom: remove bp_media_type enum typedef
  Staging: silicom: capitalize labels in the bp_media_type enum
  Staging: silicom: remove the bpctl_dev_t typdef
  Staging: silicom: remove the board_t typedef in bpctl_mod.c
  Staging: silicom: remove the typedef for bpmod_info_t
  Staging: silicom: remove typedef for dev_desc_t

 drivers/staging/silicom/bpctl_mod.c | 608 ++++++++++++++++++------------------
 1 file changed, 303 insertions(+), 305 deletions(-)

-- 
1.8.1.4

