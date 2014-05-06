Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaEFVAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:00:06 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58995 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaEFVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:00:03 -0400
X-Originating-IP: 173.246.103.110
Date: Tue, 6 May 2014 13:59:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] MAINTAINERS: Add linux-api for review of API/ABI changes
Message-ID: <20140506205953.GA16997@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it more likely that patch submitters will CC API/ABI changes
to the linux-api list, and tools like get_maintainer.pl will do so
automatically.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7578deb..52a282b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -210,6 +210,13 @@ S:	Supported
 F:	Documentation/scsi/aacraid.txt
 F:	drivers/scsi/aacraid/
 
+ABI/API
+L:	linux-api@vger.kernel.org
+F:	Documentation/ABI/
+F:	include/linux/syscalls.h
+F:	include/uapi/
+F:	kernel/sys_ni.c
+
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	lm-sensors@lm-sensors.org
-- 
2.0.0.rc0

