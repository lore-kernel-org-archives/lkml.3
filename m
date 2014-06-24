Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaFXSBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:01:41 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35006 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbaFXSBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:01:40 -0400
Date: Tue, 24 Jun 2014 14:01:38 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 0/2] aio: fixes for kernel memory disclosure in aio read events
Message-ID: <cover.1403632276.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following 2 fixes from my aio-fixes git tree at 
git://git.kvack.org/~bcrl/aio-fixes.git .  These fix a kernel memory 
disclosure issue (arbitrary kmap() & copy_to_user()) revealed in 
CVE-2014-0206 by changes that were introduced in v3.10.

Benjamin LaHaise (2):
  aio: fix aio request leak when events are reaped by userspace
  aio: fix kernel memory disclosure in io_getevents() introduced in
    v3.10

 fs/aio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
