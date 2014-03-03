Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaCCXiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:38:51 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:60638
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254AbaCCXit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:38:49 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, andy.grover@gmail.com,
        valentina.manea.m@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH v2 0/3] staging/usbip: add new uapi header usbip.h
Date: Mon,  3 Mar 2014 16:38:42 -0700
Message-Id: <cover.1393882836.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbip userspace has duplicated enum definition to report usbip device
status maintained by the kernel. Adding an usbip uapi header file will
define the kernel - userspace interface for this device status. This
new uapi file is added under usbip/uapi to keep the staging tree code
self-contained. When usbip moves to mainline drivers, this file should
be moved under uapi/linux

usbip kernel and userspace are changed to use this new header file.

Shuah Khan (3):
  staging/usbip: add uapi header to export usbip kernel interfaces
  staging/usbip: change usbip to include new uapi usbip.h
  staging/usbip: change usbip userspace to include new uapi usbip.h

 drivers/staging/usbip/uapi/usbip.h                 |   26 ++++++++++++++++++++
 drivers/staging/usbip/usbip_common.h               |   19 ++------------
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   18 +-------------
 3 files changed, 29 insertions(+), 34 deletions(-)
 create mode 100644 drivers/staging/usbip/uapi/usbip.h

-- 
1.7.10.4

