Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3JJVlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:41:39 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59993 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752293Ab3JJVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:37 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 0/6] drivers: usb: core: Adapt source to styleguide
Date: Thu, 10 Oct 2013 23:41:26 +0200
Message-Id: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I patches several files in drivers/usb/core/ to adapt them to the kernel
styleguide.

Most of these patches are whitespace/indention fixes.

As these patches are only style-patches, I just compiled the kernel, no compile
errors or warnings. So I think everything seems to be okay!

Note: I did not fix all ERROR messages from the scripts/checkpatch.pl script, as
I don't know what to do with "do not use assignments in if-condition" messages.

Matthias Beyer (6):
  drivers: usb: core: {file,hub,sysfs,usb}.c: Whitespace fixes
  drivers: usb: core: file.c: moved asterisk to variable name
  drivers: usb: core: hub.c: Comments shouldnt be C99 // comment style
  drivers: usb: core: devio.c: Coding style fixes
  drivers: usb: core: devio.c: Braces around switch
  drivers: usb: core: devio.c: Else should be on closing braces

 drivers/usb/core/devio.c |  97 ++++++++++++++++++++-------------------
 drivers/usb/core/file.c  |   8 ++--
 drivers/usb/core/hub.c   | 115 +++++++++++++++++++++++------------------------
 drivers/usb/core/sysfs.c |   5 ++-
 drivers/usb/core/usb.c   |   2 +-
 5 files changed, 116 insertions(+), 111 deletions(-)

-- 
1.8.4

