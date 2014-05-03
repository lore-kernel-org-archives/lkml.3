Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaECLqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:46:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53510 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaECLp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:45:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 00/15] staging: rtl8188eu: clean-up struct recv_buf
Date: Sat,  3 May 2014 17:15:17 +0530
Message-Id: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches remove unnecessary member variables of struct recv_buf.

navin patidar (15):
  staging: rtl8188eu: Remove function rtw_dequeue_recvbuf()
  staging: rtl8188eu: Remove function rtw_enqueue_recvbuf_to_head()
  staging: rtl8188eu: Remove function rtw_enqueue_recvbuf()
  staging: rtl8188eu: Remove 'struct list_head list' from struct
    recv_buf
  staging: rtl8188eu: Remove 'spinlock_t recvbuf_lock' from struct
    recv_buf
  staging: rtl8188eu: Remove 'dma_addr_t dma_transfer_addr' from struct
    recv_buf
  staging: rtl8188eu: Remove 'int transfer_len' from struct recv_buf
  staging: rtl8188eu: Remove pdata, phead, ptail and pend from struct
    recv_buf
  staging: rtl8188eu: Remove 'irp_pending' from struct recv_buf
  staging: rtl8188eu: Remove 'pallocated_buf' from struct recv_buf
  staging: rtl8188eu: Remove 'alloc_sz' from struct recv_buf
  staging: rtl8188eu: Remove 'u32 len' from struct recv_buf
  staging: rtl8188eu: Remove 'u32 ref_cnt' from struct recv_buf
  staging: rtl8188eu: Remove rtl8188eu_init_recvbuf() function
  staging: rtl8188eu: Remove 'u8 *pbuf' from struct recv_buf

 drivers/staging/rtl8188eu/core/rtw_recv.c         |   49 ---------------------
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |   20 ---------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |   17 +------
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h      |   17 -------
 drivers/staging/rtl8188eu/os_dep/recv_linux.c     |   15 +------
 6 files changed, 3 insertions(+), 116 deletions(-)

--
1.7.10.4

