Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965249AbaKNL2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:28:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38933 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbaKNL2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:28:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 14 Nov 2014 12:28:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fix
Message-ID: <20141114122821.08399196@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fix" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fix

to receive an IEEE 1394 (FireWire) subsystem fix:
The character device file interface for raw 1394 I/O took uninitialized
kernel stack as substitute for missing ioctl() argument data.  This could
partially show up in subsequent read() output.

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

 drivers/firewire/core-cdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-====- =-== -===-
http://arcgraph.de/sr/
