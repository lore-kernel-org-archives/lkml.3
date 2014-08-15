Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaHORX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:23:56 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34585 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaHORXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:23:55 -0400
Date: Fri, 15 Aug 2014 13:23:54 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] aio: changes for 3.17
Message-ID: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull the following changes from the aio-next git tree at 
git://git.kvack.org/~bcrl/aio-next.git .  Most of the changes this time 
around are code cleanups.

		-ben

Benjamin LaHaise (1):
  aio: remove no longer needed preempt_disable()

Gu Zheng (4):
  aio: remove the needless registration of ring file's private_data
  aio: use the macro rather than the inline magic number
  aio: fix some comments
  aio: use iovec array rather than the single one

Oleg Nesterov (2):
  aio: change exit_aio() to load mm->ioctx_table once and avoid
    rcu_read_lock()
  aio: kill the misleading rcu read locks in ioctx_add_table() and
    kill_ioctx()


-- 
"Thought is the essence of where you are now."
