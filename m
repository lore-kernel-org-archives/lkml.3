Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935277AbaH0PvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:51:20 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:20889 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001AbaH0PvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:51:19 -0400
Subject: [PATCH 0/2] block: improve I/O error print consistency
To: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        relliott@beardog.cce.hp.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, elliott@hp.com, scameron@beardog.cce.hp.com
From: Robert Elliott <elliott@hp.com>
Date: Wed, 27 Aug 2014 10:50:25 -0500
Message-ID: <20140827154628.32075.3821.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series improves some of the ratelimited
I/O error prints so what is being ratelimited is clearer.

---

Robert Elliott (2):
      block: make blk_update_request print prefix match ratelimited prefix
      block: include func name in __get_request prints


 block/blk-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

-- 
Rob Elliott, HP Server Storage  elliott@hp.com
