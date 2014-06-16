Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaFPQGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:06:08 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60856 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaFPQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:07 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 0/9] staging: rtl8188eu: Remove code implementing NAT
Date: Mon, 16 Jun 2014 21:35:37 +0530
Message-Id: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver has code which does Network address translation (NAT), and
i don't see how this code is useful for driver.

navin patidar (9):
  staging: rtl8188eu: Remove function rtw_br_client_tx()
  staging: rtl8188eu: Remove unused functons defined in rtw_br_ext.c
  staging: rtl8188eu: Remove function nat25_db_cleanup()
  staging: rtl8188eu: Remove pppoe_connection_in_progress from struct
    adapter
  staging: rtl8188eu: Remove function nat25_db_expire()
  staging: rtl8188eu: Remove function netdev_br_init()
  staging: rtl8188eu: core: Remove file  rtw_br_ext.c
  staging: rtl8188eu: Remove unused members of struct adapter
  staging: rtl8188eu: Remove file rtw_br_ext.h

 drivers/staging/rtl8188eu/Makefile             |    1 -
 drivers/staging/rtl8188eu/core/rtw_br_ext.c    | 1118 ------------------------
 drivers/staging/rtl8188eu/core/rtw_cmd.c       |    4 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c      |   18 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c      |  135 ---
 drivers/staging/rtl8188eu/include/drv_types.h  |   10 -
 drivers/staging/rtl8188eu/include/rtw_br_ext.h |   66 --
 drivers/staging/rtl8188eu/include/usb_osintf.h |    3 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |   31 -
 9 files changed, 1 insertion(+), 1385 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_br_ext.c
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_br_ext.h

--
1.7.10.4

