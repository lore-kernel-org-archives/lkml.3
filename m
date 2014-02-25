Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBYNgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:36:11 -0500
Received: from ozlabs.org ([203.10.76.45]:40792 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaBYNgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:36:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <bp@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] tools: Unify export.h
In-Reply-To: <20140225070020.GA19504@pd.tnic>
References: <1393153753-2369-1-git-send-email-bp@alien8.de> <87eh2s55tg.fsf@rustcorp.com.au> <20140225070020.GA19504@pd.tnic>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 25 Feb 2014 22:52:02 +1030
Message-ID: <87eh2r4c2d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@suse.de> writes:
> On Tue, Feb 25, 2014 at 12:09:23PM +1030, Rusty Russell wrote:
>> Should we get more ambitious and start a fake-kernel/ directory where
>> we can put userspace equivs/stubs of kernel functionality?
>
> Dunno - people like to do that now, it seems.
>
> In any case, cleanups and unifications like that would definitely help
> if we decide to do that because, in this particular example, we have
> only one export.h to go and fish out.

Agreed.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty
