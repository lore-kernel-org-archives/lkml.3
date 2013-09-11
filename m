Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3IKQG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:06:27 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:51214 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755551Ab3IKQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:04:55 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>, Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, devel@driverdev.osuosl.org
Subject: [PATCH 11/11] staging: usbip: Increment version to 1.2.0
Date: Wed, 11 Sep 2013 18:06:57 +0200
Message-Id: <1378915617-29791-12-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
References: <1378732471-5967-1-git-send-email-dominik.paulus@fau.de>
 <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 099d24b..0b0e035 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
+AC_INIT([usbip-utils], [1.2.0], [linux-usb@vger.kernel.org])
 
 CURRENT=0
 REVISION=1
-- 
1.8.4

