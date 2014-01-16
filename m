Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaAPAxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:53:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43111 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaAPAxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:53:13 -0500
Date: Wed, 15 Jan 2014 16:53:12 -0800 (PST)
Message-Id: <20140115.165312.1607401549329090025.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
        krebbel@linux.vnet.ibm.com, jejb@parisc-linux.org,
        benh@kernel.crashing.org, mingo@redhat.com, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat: fix sys_fanotify_mark
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140115114557.GC6638@osiris>
References: <20140115114557.GC6638@osiris>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 15 Jan 2014 12:45:57 +0100

> 91c2e0bcae72 "unify compat fanotify_mark(2), switch to COMPAT_SYSCALL_DEFINE"
> added a new unified compat fanotify_mark syscall to be used by all
> architectures.
> Unfortunately the unified version merges the split mask parameter in a
> wrong way: the lower and higher word got swapped.
> 
> This was discovered with glibc's tst-fanotify test case.
> 
> Reported-by: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: stable@vger.kernel.org # v3.10+
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
