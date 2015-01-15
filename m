Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbbAOHMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:12:33 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49429 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbAOHMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:12:31 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0F7Bmgi016239, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 0/2] Fix PM deadlock and card detection problem
Date: Thu, 15 Jan 2015 15:14:43 +0800
Message-ID: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patchset fixes a deadlock situation of runtime PM methods and minimize
card detection "deadtime" during runtime suspending.

Roger Tseng (2):
  mfd: rtsx_usb: Fix runtime PM deadlock
  mfd: rtsx_usb: Defer autosuspend while card exists

 drivers/mfd/rtsx_usb.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

-- 
2.1.3

