Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3KFIha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:37:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3KFIh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:37:28 -0500
Date: Wed, 6 Nov 2013 09:37:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] pktcdvd, floppy for 3.13
Message-ID: <alpine.LNX.2.00.1311060935590.835@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

to get two very simple patches for pktcdvd and floppy doc.

I know it's quite late for 3.13, sorry for that. OTOH, the patches are so 
simple, that no harm can be caused :)

Thanks!



Ben Harris (1):
      floppy: Correct documentation of driver options when used as a module.

Dan Carpenter (1):
      pktcdvd: debugfs functions return NULL on error

 Documentation/blockdev/floppy.txt |    6 +++---
 drivers/block/pktcdvd.c           |   22 ++++------------------
 2 files changed, 7 insertions(+), 21 deletions(-)

-- 
Jiri Kosina
SUSE Labs
