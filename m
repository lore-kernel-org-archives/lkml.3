Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaHEHzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:55:18 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:57818 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756849AbaHEHzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:55:16 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] tty: serial: msm: Fix checkpatch errors
Date: Tue,  5 Aug 2014 13:21:58 +0530
Message-Id: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiran Padwal (5):
  tty: serial: msm: remove braces {} in msm_serial.c
  tty: serial: msm: Fix 'Missing a blank line after declarations'
    warning
  tty: serial: msm: Fix style warnings relating to printk()
  tty: serial: msm: Fix 'else is not generally useful after a break or
    return' warning
  tty: serial: msm: Fix 'void function return statements are not
    generally useful' warning

 drivers/tty/serial/msm_serial.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

-- 
1.7.9.5

