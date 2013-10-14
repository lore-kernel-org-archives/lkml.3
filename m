Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3JNTqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:46:54 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59352 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756346Ab3JNTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:46:53 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH v2 0/5] Coding style fixes
Date: Mon, 14 Oct 2013 21:46:35 +0200
Message-Id: <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20131014181214.GB6023@kroah.com>
References: <20131014181214.GB6023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually this is the third reroll of this patchseries, but I just figured out
how to place this "v2" thing in the patches... sorry for that!

As Greg KH requested: 

I splitted the coding style fixes into several patches. The replacing of spaces
by tabs in proc_reapurbnonblock() and proc_control_compat() is splitted into two
patches. As the patch for adding braces around the switch-block in here did not
apply (don't know why), this patch series resubmits it (also splitted).

Note: This patch series makes the remaining patches from the origin patch series
_obsolete_. So you have not to apply 5/6 and 6/6 from the origin patch series
(I would be confused if it still works)!

Btw: If you are stressed out by me sending coding style fixes, I wouldn't take
it wrong if you would redirect me to a submaintainer or so!

Best regards!

Matthias Beyer (5):
  drivers: usb: core: devio.c: Spaces to tabs for proc_reapurbnonblock()
  drivers: usb: core: devio.c: Spaces to tabs for proc_control_compat()
  drivers: usb: core: devio.c: Braces around if-elseif-else
  drivers: usb: core: devio.c: Reindented switch-block
  drivers: usb: core: devio.c: Put arguments on new line

 drivers/usb/core/devio.c | 95 +++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 46 deletions(-)

-- 
1.8.4

