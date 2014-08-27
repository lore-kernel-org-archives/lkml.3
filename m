Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365AbaH0Pwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:52:49 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22668 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934674AbaH0Pwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:52:47 -0400
Subject: [PATCH 0/2] fs: merge I/O error prints into one line
To: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        relliott@beardog.cce.hp.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, elliott@hp.com, scameron@beardog.cce.hp.com
From: Robert Elliott <elliott@hp.com>
Date: Wed, 27 Aug 2014 10:51:54 -0500
Message-ID: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series merges I/O error prints into one
line and makes rate limited messages clearer.

---

Robert Elliott (2):
      fs: merge I/O error prints into one line
      fs: clarify rate limit suppressed buffer I/O errors


 fs/buffer.c |   38 +++++++++-----------------------------
 1 files changed, 9 insertions(+), 29 deletions(-)

-- 
Rob Elliott, HP Server Storage  elliott@hp.com
