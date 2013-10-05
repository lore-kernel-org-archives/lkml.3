Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3JEQLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:11:20 -0400
Received: from libra.uberspace.de ([95.143.172.171]:45158 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752053Ab3JEQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:11:17 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 0/5] Cleanup in drivers/usb/core/hcd.c
Date: Sat,  5 Oct 2013 18:02:05 +0200
Message-Id: <cover.1380986962.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I did some cleanup in 

    drivers/usb/core/hcd.c

of ERROR messages from "scripts/checkpatch.pl --file". Not all ERRORs are fixed,
there are some remaining with "assignment in if statement".

It's based on 7dee8df, which is Linus current master. I compiled it without
errors. Checkpatch script gives me some warnings, which are remaining warnings
of the file, I didn't introduce them!

Best regards!

Matthias Beyer (5):
  drivers: usb: core: hcd: moved asterix to variable
  drivers: usb: core: hcd: Whitespace fixes
  drivers: usb: core: hcd: replaced C99 // comments
  drivers: usb: core: hcd: removed braces for return statements
  drivers: usb: core: hcd: if-else-braces fixed

 drivers/usb/core/hcd.c | 80 +++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

-- 
1.8.4

