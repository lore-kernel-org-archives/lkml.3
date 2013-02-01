Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3BAQIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:08:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38490 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab3BAQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:08:23 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 0/2] staging: android: ashmem: add 32bit compat support
Date: Fri,  1 Feb 2013 16:07:59 +0000
Message-Id: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This set of patches will add support for existing 32bit Android ashmem
syscalls on 64bit platforms. They also fix the ashmem pin/unpin interface
without affecting the 32bit ABI but imposing a new, correct one, for any
future 64bit Android userspace.

They have been successfully tested on 32bit platforms(VExpress 4xA9) and
64bit platforms(RTSMv8) running 32bit Android userspace and 64bit Linux +
ashmem unit tests.

Best Regards,
Serban Constantinescu
PDSW Engineer ARM Ltd.


Serban Constantinescu (2):
  staging: android: ashmem: fix ashmem pin/unpin interface
  staging: android: ashmem: Add support for 32bit ashmem calls in a
    64bit kernel

 drivers/staging/android/ashmem.c |   65 ++++++++++++++++++++++++++++++--------
 drivers/staging/android/ashmem.h |   19 +++++++++--
 2 files changed, 68 insertions(+), 16 deletions(-)

-- 
1.7.9.5

