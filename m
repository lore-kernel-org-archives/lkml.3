Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3GDEm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:42:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3GDEm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:42:56 -0400
Date: Wed, 3 Jul 2013 21:43:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Michal Marek <mmarek@suse.cz>, Daniel Tang <dt.tangr@gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the kbuild tree
Message-Id: <20130703214300.11d9223a.akpm@linux-foundation.org>
In-Reply-To: <20130704143353.e695ca64b17705c842676870@canb.auug.org.au>
References: <20130704143353.e695ca64b17705c842676870@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013 14:33:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got conflicts in
> tools/include/tools/be_byteshift.h and tools/include/tools/le_byteshift.h
> between commit b35310627f39 ("tools/include: use stdint types for
> user-space byteshift headers") from the kbuild tree and commit
> "scripts/sortextable.c: fix building on non-Linux systems" from the
> akpm tree.
> 
> As fas as I can tell, these patches do the same thing except one uses
> stdint.h and the other inttypes.h.  I just dropped the akpm tree patch.

Well OK, but new patches really shouldn't be popping up in the middle
of the merge window like this.

AFAICT Yaakov (re)sent this patch way back in April, so it should have
been in -next for a long time.  Something has gone wrong here.
