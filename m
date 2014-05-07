Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaEGD6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:58:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39387 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaEGD6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:58:07 -0400
X-Google-Original-Message-ID: <1399435056-32386-1-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 00/13]staging: rtl8188eu:  Remove unused functions and variables
Date: Wed,  7 May 2014 09:27:23 +0530
Message-Id: <5369af4d.8482440a.284c.1d3c@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

Following patches remove unused functions, variables and functions with empty
definition.

navin patidar (13):
  staging: rtl8188eu: Remove 'semaphore allrxreturnevt' from struct
    recv_priv
  staging: rtl8188eu: Remove unused member variables of struct
    recv_priv
  staging: rtl8188eu: Remove 'spinlock_t lock' from struct recv_priv
  staging: rtl8188eu: Remove struct zero_bulkout_context
  staging: rtl8188eu: Remove function rtw_os_recv_resource_init()
  staging: rtl8188eu: Remove function rtw_os_recv_resource_free()
  staging: rtl8188eu: Remove function rtw_hostapd_mlme_rx()
  staging: rtl8188eu: Remove function rtw_os_recvbuf_resource_free()
  staging: rtl8188eu: Remove unused inline function recvframe_push()
  staging: rtl8188eu: Remove unused inline function get_rx_status()
  staging: rtl8188eu: Remove 'void  *precvbuf' from struct recv_frame
  staging: rtl8188eu: Remove 'int frame_tag' from struct recv_frame
  staging: rtl8188eu: Remove 'u8 fragcnt' from struct recv_frame

 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    2 --
 drivers/staging/rtl8188eu/core/rtw_recv.c        |    8 -----
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c   |    2 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c    |    1 -
 drivers/staging/rtl8188eu/include/recv_osdep.h   |    4 ---
 drivers/staging/rtl8188eu/include/rtw_recv.h     |   36 ----------------------
 drivers/staging/rtl8188eu/os_dep/recv_linux.c    |   25 ---------------
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    7 -----
 8 files changed, 1 insertion(+), 84 deletions(-)

--
1.7.10.4

