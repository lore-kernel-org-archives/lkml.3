Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3AWQNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:13:05 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:47601 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3AWQND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:13:03 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] MAINTAINERS: update avr32 web ressources
Date: Wed, 23 Jan 2013 17:12:44 +0100
Message-Id: <1358957564-5678-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20130123142409.GB30142@samfundet.no>
References: <20130123142409.GB30142@samfundet.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Web ressource http://avr32linux.org/ is no longer
available. We add the mirror of the web page foud
at http://mirror.egtvedt.no/avr32linux.org/.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3105c48..d605454 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1489,7 +1489,7 @@ AVR32 ARCHITECTURE
 M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
 M:	Hans-Christian Egtvedt <egtvedt@samfundet.no>
 W:	http://www.atmel.com/products/AVR32/
-W:	http://avr32linux.org/
+W:	http://mirror.egtvedt.no/avr32linux.org/
 W:	http://avrfreaks.net/
 S:	Maintained
 F:	arch/avr32/
-- 
1.7.11.7

