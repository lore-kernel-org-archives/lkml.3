Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbaCSWOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:14:54 -0400
Received: from ced.ryick.net ([82.229.97.62]:40203 "EHLO ced.ryick.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbaCSWOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:14:50 -0400
From: =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
Subject: [PATCH 0/2] coding style for drivers/staging/usbip
Date: Wed, 19 Mar 2014 23:04:55 +0100
Message-Id: <1395266697-8699-1-git-send-email-ced@ryick.net>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various coding style fixes for drivers/staging/usbip

Cédric Cabessa (2):
  coding style: fix quoted string split across lines
  coding style: fix line over 80 characters

 drivers/staging/usbip/stub_tx.c      | 16 ++++++++--------
 drivers/staging/usbip/usbip_common.c | 10 ++++------
 drivers/staging/usbip/vhci_hcd.c     | 33 ++++++++++++++++++++++-----------
 drivers/staging/usbip/vhci_sysfs.c   |  4 ++--
 4 files changed, 36 insertions(+), 27 deletions(-)

-- 
1.8.3.1

