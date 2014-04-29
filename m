Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbaD2VWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:22:24 -0400
Received: from kanga.kvack.org ([205.233.56.17]:60507 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbaD2VWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:22:23 -0400
Date: Tue, 29 Apr 2014 17:22:22 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] aio: change exit_aio() to load mm->ioctx_table once and avoid rcu_read_lock()
Message-ID: <20140429212222.GA28959@kvack.org>
References: <20140429183915.GA32513@redhat.com> <20140429184004.GB32521@redhat.com> <20140429204217.GO14608@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429204217.GO14608@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 04:42:17PM -0400, Benjamin LaHaise wrote:
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Your patch does not apply because it is whitespace damaged.  Please resend 
> and verify that it applies with 'git am'.

Whoops, it's not whitespace damange, but rather that it doesn't apply with 
the other changes that are queued up in the aio-next tree.  You can find a 
copy of that tree at git://git.kvack.org/~bcrl/aio-next.git .  The change 
that conflicts is an additional parameter to kill_ioctx().

		-ben
-- 
"Thought is the essence of where you are now."
