Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3BCLES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:04:18 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53611 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3BCLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:04:15 -0500
Date: Sun, 3 Feb 2013 12:04:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] liblockdep: wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130203110410.GA11739@gmail.com>
References: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I applied your patches and did:

  cd tools/lib/lockdep
  make

and got:

comet:~/tip/tools/lib/lockdep> make
  CC FPIC            common.o
In file included from ./uinclude/linux/lockdep.h:13:0,
                 from 
/fast/mingo/tip/tools/lib/lockdep/common.c:4:
./../../../include/linux/lockdep.h:21:27: fatal error: linux/linkage.h: No such file or directory
compilation terminated.
make: *** [common.o] Error 1

Thanks,

	Ingo
