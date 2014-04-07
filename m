Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaDGS06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:26:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaDGS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:26:56 -0400
Date: Mon, 7 Apr 2014 11:26:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20140407112654.e2172fd7c0df975bf79df388@linux-foundation.org>
In-Reply-To: <20140407145242.1958251349e0b6c6c8923f46@canb.auug.org.au>
References: <20140407145242.1958251349e0b6c6c8923f46@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014 14:52:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> fs/ocfs2/suballoc.c: In function 'ocfs2_block_group_set_bits':
> fs/ocfs2/suballoc.c:1357:2: error: implicit declaration of function 'trace_ocfs2_block_group_set_bits' [-Werror=implicit-function-declaration]
>   trace_ocfs2_block_group_set_bits(bit_off, num_bits);
>   ^
> 
> I have no idea how to track this down :-( The only patches affecting this
> code are now in Linus' tree.  I can only assume that some implicitly
> included header file is no longer included.  I have just left it broken
> for now.

I can't reproduce this with either mainline or linux-next.  Pulled half
an hour ago, powerpc allyesconfig.

