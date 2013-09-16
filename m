Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3IPGri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:47:38 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:34092 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3IPGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:47:35 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 0/2] Enable PPS reporting for USB serial devices (v3)
Date: Mon, 16 Sep 2013 08:40:58 +0200
Message-Id: <1379313660-2510-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Mon, 16 Sep 2013 08:47:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This series enable the PPS reporting for USB serial devices. This
third submission improve commit messages, and fix some coding
guidelines. The last patch of the v2 will be integrated in an more
global reworking of the pl2303 driver.

Paul Chavent (2):
  USB : serial : call handle_dcd_change in ftdi driver.
  USB : serial : invoke dcd_change ldisc's handler.

 Documentation/pps/pps.txt     | 15 +++++++++++++++
 drivers/usb/serial/ftdi_sio.c | 10 +++++++++-
 drivers/usb/serial/generic.c  | 10 ++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

-- 
1.7.12.1

