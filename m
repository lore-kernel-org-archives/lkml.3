Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab3E2Nmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:42:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586Ab3E2Nmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:42:53 -0400
Date: Wed, 29 May 2013 15:42:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] pktcdvd fix
Message-ID: <alpine.LNX.2.00.1305291540300.30576@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

to receive one pktcdvd fix. It fixes a highly theoretical issue with using 
pktcdvd to work with media that'd be larger than 2TB :) But it's a correct 
fix and makes static checkers shut up about improperly cleaning upper 
32bits.

Thanks.


Dan Carpenter (1):
      pktcdvd: silence static checker warning

 drivers/block/pktcdvd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs
