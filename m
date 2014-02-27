Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaB0VnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:43:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaB0VnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:43:09 -0500
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/2 v2] bdi: Fix hung tasks and oops in writeback
Date: Thu, 27 Feb 2014 22:43:00 +0100
Message-Id: <1393537382-26255-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello,

  this is a second version of patches to fix some issues in current
flusher work implementation. Since v1 I have fixed some whitespace
issues and added Reviewed-by tags. Jens, can you please merge the
patches with Linus? Thanks!

								Honza
