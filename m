Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab3DAQmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:42:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36589
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759035Ab3DAQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:42:31 -0400
Date: Mon, 1 Apr 2013 12:42:30 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: jforbes@redhat.com, rdunlap@xenotime.net
Subject: [PATCH] DocBook/device-drivers.tmpl: fix 8250.c reference
Message-ID: <20130401164230.GO12938@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

htmldocs will fail, because device-drivers.tmpl references the
non-existant file 8250.c (which got renamed to 8250_core.c)

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -227,7 +227,7 @@ X!Isound/sound_firmware.c
   <chapter id="uart16x50">
      <title>16x50 UART Driver</title>
 !Edrivers/tty/serial/serial_core.c
-!Edrivers/tty/serial/8250/8250.c
+!Edrivers/tty/serial/8250/8250_core.c
   </chapter>
 
   <chapter id="fbdev">
