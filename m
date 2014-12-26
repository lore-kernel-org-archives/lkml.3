Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaLZO7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:59:13 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42872 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLZO7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:59:08 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] doc: driver-model: improve wording "is provide the"
Date: Fri, 26 Dec 2014 06:57:49 -0800
Message-Id: <1419605869-13455-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the wording by changing it from "is provide the" to
"is to give the".

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 Documentation/driver-model/bus.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.txt
index 6754b2d..b577a45 100644
--- a/Documentation/driver-model/bus.txt
+++ b/Documentation/driver-model/bus.txt
@@ -45,7 +45,7 @@ them are inherently bus-specific. Drivers typically declare an array
 of device IDs of devices they support that reside in a bus-specific
 driver structure. 
 
-The purpose of the match callback is provide the bus an opportunity to
+The purpose of the match callback is to give the bus an opportunity to
 determine if a particular driver supports a particular device by
 comparing the device IDs the driver supports with the device ID of a
 particular device, without sacrificing bus-specific functionality or
-- 
2.1.4

