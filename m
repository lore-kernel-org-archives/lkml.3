Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbaD3OQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010AbaD3OQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:16:07 -0400
Date: Wed, 30 Apr 2014 16:15:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] aio: ioctx_table/rcu_read_lock cleanups
Message-ID: <20140430141552.GA18539@redhat.com>
References: <20140429183915.GA32513@redhat.com> <20140429184004.GB32521@redhat.com> <20140429204217.GO14608@kvack.org> <20140429212222.GA28959@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429212222.GA28959@kvack.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Benjamin LaHaise wrote:
>
> Whoops, it's not whitespace damange, but rather that it doesn't apply with
> the other changes that are queued up in the aio-next tree.  You can find a
> copy of that tree at git://git.kvack.org/~bcrl/aio-next.git .  The change
> that conflicts is an additional parameter to kill_ioctx().

Please see v2. Rebased, added another untested cleanup.

Kent, it seems that you agree at least with 1/2, I'll appreciate your ack ;)

And it seems that we can kill mm->ioctx_lock, with the minimal complications
we can move it into kioctx_table, but this is minor.

Oleg.

