Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3KDI1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:27:36 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:59920 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3KDI1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:27:35 -0500
Date: Mon, 4 Nov 2013 09:27:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Remove h8300 platform support
In-Reply-To: <20131104005707.GA13325@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1311040924290.20164@ayla.of.borg>
References: <20131104005707.GA13325@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Günther,

On Sun, 3 Nov 2013, Guenter Roeck wrote:
>       Drop MAINTAINERS entry for H8/300

Can you please add the following patch, or fold it into the above one?

Thanks!

>From c0f6645ed8708f1bf8c669364017016d1a710c3c Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 4 Nov 2013 09:22:01 +0100
Subject: [PATCH] CREDITS: Add Yoshinori Sato for h8300

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 CREDITS |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/CREDITS b/CREDITS
index 0640e1650483..b928516eea90 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3152,6 +3152,11 @@ N: Dipankar Sarma
 E: dipankar@in.ibm.com
 D: RCU
 
+N: Yoshinori Sato
+E: ysato@users.sourceforge.jp
+D: uClinux for Renesas H8/300 (H8300)
+D: http://uclinux-h8.sourceforge.jp/
+
 N: Hannu Savolainen
 E: hannu@opensound.com
 D: Maintainer of the sound drivers until 2.1.x days.
-- 
1.7.9.5

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
