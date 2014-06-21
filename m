Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaFUMuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:50:07 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39396 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaFUMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:50:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 0/7] staging: rtl8188eu: Consolidate usb operation code.
Date: Sat, 21 Jun 2014 18:19:30 +0530
Message-Id: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

navin patidar (7):
  staging: rtl8188eu: Merge hal/usb_ops_linux.c into
    os_dep/usb_ops_linux.c
  staging: rtl8188eu: Remove macros specific to kernel version < 2.6.12
  staging:rtl8188eu:usb_ops.h:Remove unused enum, macros and function
    declaration
  staging: rtl8188eu: usb_ops.h: Remove macro rtw_usb_control_msg()
  staging: rtl8188eu: Remove inline function
    rtw_inc_and_chk_continual_urb_error()
  staging: rtl8188eu: Remove continual_urb_error from struct dvobj_priv
  staging: rtl8188eu: Merge usb_ops.h into usb_ops_linux.h

 drivers/staging/rtl8188eu/Makefile                |    1 -
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |    1 -
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    1 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    2 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    1 -
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |  665 ---------------------
 drivers/staging/rtl8188eu/include/drv_types.h     |    2 -
 drivers/staging/rtl8188eu/include/usb_ops.h       |  112 ----
 drivers/staging/rtl8188eu/include/usb_ops_linux.h |   25 +
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c     |    2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |    4 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |  630 ++++++++++++++++++-
 16 files changed, 658 insertions(+), 794 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/usb_ops_linux.c
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_ops.h

--
1.7.10.4

