Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3GABML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:12:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54831 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868Ab3GABMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:12:10 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] cdrom: neatening
Date: Sun, 30 Jun 2013 18:11:55 -0700
Message-Id: <cover.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (12):
  cdrom: convert cdinfo to cd_dbg
  cdrom: Remove unused CHECKAUDIO macro
  cdrom: Remove obfuscating IOCTL_IN and IOCTL_OUT macros
  cdrom: Remove prototype for open_for_data
  cdrom: Remove unnecessary check_for_audio_disc prototype
  cdrom: Remove unnecessary sanitize_format prototype
  cdrom: Move mmc_ioctls above cdrom_ioctl to remove unnecessary prototype
  cdrom: Remove cdrom_get_last_written prototype
  cdrom: Remove cdrom_get_next_writeable prototype
  cdrom: Remove cdrom_count_tracks prototype
  cdrom: Remove unnecessary prototype for cdrom_mrw_exit
  cdrom: Remove unnecessary prototype for cdrom_get_disc_info

 drivers/cdrom/cdrom.c | 1359 +++++++++++++++++++++++++------------------------
 1 file changed, 682 insertions(+), 677 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

