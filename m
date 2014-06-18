Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966332AbaFRMH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:07:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966020AbaFRMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:07:57 -0400
Date: Wed, 18 Jun 2014 14:07:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] floppy
Message-ID: <alpine.LNX.2.00.1406181406401.2303@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

to receive formatting fix for floppy driver; preferably for 3.16 still. 
The branch is based on your for-3.16/drivers.

Thanks!

----------------------------------------------------------------
Jiri Kosina (1):
      floppy: format block0 read error message properly

 drivers/block/floppy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jiri Kosina
SUSE Labs
