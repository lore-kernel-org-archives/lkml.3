Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaCJIg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:36:59 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39239 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaCJIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:36:57 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 0/2] Rename struct dev_state to struct usb_dev_state
Date: Mon, 10 Mar 2014 10:36:39 +0200
Message-Id: <1394440601-13573-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is needed outside usbcore and exposed in include/linux/usb.h,
it conflicts with enum dev_state in rt2x00 wireless driver and breaks
the build.

Mark it as usb specific to avoid conflicts in the future and update
USB/IP to use the new name.

Valentina Manea (2):
  usbcore: rename struct dev_state to struct usb_dev_state
  staging: usbip: rename struct dev_state to usb_dev_state

 drivers/staging/usbip/stub_dev.c |   4 +-
 drivers/usb/core/devio.c         | 112 +++++++++++++++++++--------------------
 drivers/usb/core/hub.c           |  12 ++---
 drivers/usb/core/hub.h           |   2 +-
 drivers/usb/core/usb.h           |   4 +-
 include/linux/usb.h              |   6 +--
 6 files changed, 70 insertions(+), 70 deletions(-)

-- 
1.8.1.2

