Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaFGXww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:52:52 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:35594 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFGXwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:52:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140604202758.GC22927@quack.suse.cz>
References: <20140604202758.GC22927@quack.suse.cz>
Date: Sat, 7 Jun 2014 16:52:49 -0700
X-Google-Sender-Auth: R9JL4YjCKw0FGg688Q0GvwXay_Q
Message-ID: <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
Subject: Re: [GIT PULL] Reiserfs & ext3 changes for 3.16-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 1:27 PM, Jan Kara <jack@suse.cz> wrote:
>   Hello Linus,
>
>   could you please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus
>
> to get big reiserfs cleanup from Jeff, an ext3 deadlock fix, and some small
> cleanups.

This does not work at all for me:

  fs/reiserfs/do_balan.c: In function ‘balance_leaf_new_nodes’:
  fs/reiserfs/do_balan.c:1248:3: error: implicit declaration of
function ‘format_bh’ [-Werror=implicit-function-declaration]
     RFALSE(!buffer_journaled(tb->S_new[i])
     ^

Hmm? "format_bh()"?

           Linus
