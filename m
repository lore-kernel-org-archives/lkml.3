Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaANJlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:41:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48154 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaANJlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:41:03 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 0/3] zram stats rework and code cleanup
Date: Tue, 14 Jan 2014 12:37:37 +0300
Message-Id: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.2.487.g7559984
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes code clean up and zram stats rework.

Sergey Senozhatsky (3):
  zram: drop `init_done' struct zram member
  zram: do not pass rw argument to __zram_make_request()
  zram: rework reported to end-user zram statistics

 drivers/block/zram/zram_drv.c | 213 ++++++++++++++----------------------------
 drivers/block/zram/zram_drv.h |  18 ++--
 2 files changed, 76 insertions(+), 155 deletions(-)

-- 
1.8.5.2.487.g7559984

