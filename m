Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaI3ErX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:47:23 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54116 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaI3ErT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:47:19 -0400
Message-ID: <542A35E6.8020100@gmail.com>
Date: Mon, 29 Sep 2014 21:47:34 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org
CC: rajatjain@juniper.net, groeck@juniper.net
Subject: [PATCH 3/4] MAINTAINERS: Add new device driver entry for PEX pex8xxx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3705430..0ef7a92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7003,6 +7003,13 @@ S:	Maintained
 F:	include/linux/personality.h
 F:	include/uapi/linux/personality.h
 
+PEX8XXX I2C DRIVER
+M:	Rajat Jain <rajatjain@juniper.net>
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	drivers/pci/pex8xxx_i2c.c
+F:	include/linux/i2c/pex8xxx_i2c.h
+
 PHONET PROTOCOL
 M:	Remi Denis-Courmont <courmisch@gmail.com>
 S:	Supported
-- 
1.7.9.5

