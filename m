Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaB1A1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:27:34 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:58520
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbaB1A1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:27:32 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 0/3] staging/usbip: add new uapi header usbip.h
Date: Thu, 27 Feb 2014 17:27:24 -0700
Message-Id: <cover.1393542201.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip userspace has duplicated enum definition to report usbip device
status maintained by the kernel. Adding an usbip uapi header file will
define the kernel - userspace interface for this device status.

Shuah Khan (3):
  staging/usbip: add uapi header to export usbip kernel interfaces
  staging/usbip: change usbip to include new uapi usbip.h
  staging/usbip: change usbip userspace to include new uapi usbip.h

 drivers/staging/usbip/usbip_common.h               |   19 ++------------
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   20 +++------------
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/usbip.h                         |   26 ++++++++++++++++++++
 4 files changed, 32 insertions(+), 34 deletions(-)
 create mode 100644 include/uapi/linux/usbip.h

-- 
1.7.10.4

