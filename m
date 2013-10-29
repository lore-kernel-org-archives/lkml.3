Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab3J2Dvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:51:55 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:37747 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab3J2Dvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:51:54 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 00/11 V2] Staging: bcm: Cleanup Adapter.h
Date: Mon, 28 Oct 2013 23:51:37 -0400
Message-Id: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix several issues in Adapter.h

Kevin McKinney (11):
  Staging: bcm: Fix WARNING: space prohibited before semicolon.
  Staging: bcm: Remove typedef for _U_IP_ADDRESS and call directly.
  Staging: bcm: Replace USHORT with unsigned short in Adapter.h
  Staging: bcm: Replaces UCHAR with u8 in Adapter.h
  Staging: bcm: Replace ULONG with unsigned long or u32 in Adapter.h
  Staging: bcm: Replace B_UINT16 with u16 in Adapter.h
  Staging: bcm: Replace B_UINT8 with u8 in Adapter.h
  Staging: bcm: Replace UINT32 with u32 in Adapter.h
  Staging: bcm: Replace UINT with unsigned int in Adapter.h
  Staging: bcm: Replace PVOID with void * in Adapter.h
  Staging: bcm: Replace LARGE_INTEGER with u64 in Adapter.h

 drivers/staging/bcm/Adapter.h |  298 ++++++++++++++++++++---------------------
 drivers/staging/bcm/Bcmchar.c |    2 +-
 drivers/staging/bcm/CmHost.c  |    8 +-
 drivers/staging/bcm/Misc.c    |    8 +-
 4 files changed, 158 insertions(+), 158 deletions(-)

-- 
1.7.9.5

