Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab3DDMcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:32:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64417 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759765Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 0/8] Android Binder IPC Fixes
Date: Thu,  4 Apr 2013 13:32:30 +0100
Message-Id: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This set of patches will clean-up and fix some of the issues that arise
with the current binder interface when moving to a 64bit kernel. All these
changes will not affect the existing 32bit Android interface and are meant
to stand as the base for the 64bit binder compat layer.

This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
kernel binder compat layer.

Best Regards,
Serban Constantinescu

Serban Constantinescu (8):
  staging: android: binder: replace explicit size types
  staging: android: binder: replace IOCTL types with user-exportable
    types
  staging: android: binder: fix binder interface for 64bit compat layer
  staging: android: binder: fix printk() format specifier
  staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
  staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
  staging: android: binder: fix alignment issues
  staging: android: binder: replace types with portable ones

 drivers/staging/android/binder.c |  114 +++++++++++++++++++-------------------
 drivers/staging/android/binder.h |   54 +++++++++---------
 2 files changed, 84 insertions(+), 84 deletions(-)

-- 
1.7.9.5

