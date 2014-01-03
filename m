Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaACJNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:13:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaACJNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:13:01 -0500
Date: Fri, 3 Jan 2014 10:12:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] pktcdvd
Message-ID: <alpine.LNX.2.00.1401031011330.14951@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull 

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

into your 'for-3.14/drivers' branch to receive:


- fix for return value propagation in pktcdvd, from Julia Lawall


Thanks.

Julia Lawall (1):
      pktcdvd: fix error return code

 drivers/block/pktcdvd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs
