Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaCHJhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:37:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37475 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaCHJho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:37:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 8 Mar 2014 10:37:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fixes
Message-ID: <20140308103732.5cdb47af@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fixes" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fixes

to receive the following IEEE 1394 (FireWire) subsystem changes.
These fix a use-after-free regression since v3.4 and an initialization
regression since v3.10.

Stefan Richter (2):
      firewire: net: fix use after free
      firewire: ohci: fix probe failure with Agere/LSI controllers

 drivers/firewire/net.c  |  6 +++---
 drivers/firewire/ohci.c | 15 ++-------------
 2 files changed, 5 insertions(+), 16 deletions(-)

Thanks.  
-- 
Stefan Richter
-=====-====- --== -=---
http://arcgraph.de/sr/
