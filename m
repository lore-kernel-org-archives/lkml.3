Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaAQN5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:57:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaAQN5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:57:06 -0500
Date: Fri, 17 Jan 2014 14:57:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] floppy
Message-ID: <alpine.LNX.2.00.1401171455060.23018@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please consider pulling

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

into your for-3.14/drivers branch to receive

Jiri Kosina (1):
      floppy: bail out in open() if drive is not responding to block0 read

 drivers/block/floppy.c  |   36 +++++++++++++++++++++++++++---------
 include/uapi/linux/fd.h |    3 ++-
 2 files changed, 29 insertions(+), 10 deletions(-)

Thanks!

-- 
Jiri Kosina
SUSE Labs
