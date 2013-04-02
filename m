Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427Ab3DBQj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:39:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab3DBQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:39:57 -0400
Date: Tue, 2 Apr 2013 18:39:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Rob Landley <rob@landley.net>
cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] Documentation: fix a path in a DocBook template
Message-ID: <Pine.LNX.4.64.1304021830470.31999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:990mF7ldxWFJLXJArWlL5qi7xKKlH2e+LfR/0hPIBNR
 Vz/53M1tBXbL3RBuDqQYkHByursXsgPcZ8rRYvkxPtOYAi5uTQ
 Ms5lyL0ehmeXX4+kcuSppSUxaDU0D/1pHqSXMzbk+jDhScGkSl
 F4Xmr/RfHoDS9+1N6rOJB7b3l0HjyriJXGsB9AVTWlaI+QUEmv
 3ipqZWaOWea8Gs5YbUPRgx4Yun+1+wjnJXhZ9aRvHfPbW/qVzS
 GqzpTkOh5RkKbsQIlPueyThEd2bKn31v0si8Uqbk7uWNcbVZIP
 AOv66vQO1B9yZBw/+FS3oXwYVdKSUAa1rVTEodgH23TioYyqUH
 4zTjWXRmhn+y4RGtuhzyuBT3+eoSi6aJbc9ickjQm7nzEv5u8w
 fSEm1nj1MIpFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A wrong path to a driver breaks DocBook built.

Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

A fix for 3.9

 Documentation/DocBook/device-drivers.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 7514dbf..c36892c 100644
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
-- 
1.7.2.5

