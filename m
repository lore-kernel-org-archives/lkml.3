Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaBYFql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:46:41 -0500
Received: from ozlabs.org ([203.10.76.45]:33568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaBYFqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:46:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] tools: Unify export.h
In-Reply-To: <1393153753-2369-1-git-send-email-bp@alien8.de>
References: <1393153753-2369-1-git-send-email-bp@alien8.de>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 25 Feb 2014 12:09:23 +1030
Message-ID: <87eh2s55tg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:
> From: Borislav Petkov <bp@suse.de>
>
> So tools/ has been growing three, at a different stage of their
> development export.h headers and so we should unite into one. Add
> tools/include/ to the include path of virtio and liblockdep to pick the
> shared header now.

Should we get more ambitious and start a fake-kernel/ directory where
we can put userspace equivs/stubs of kernel functionality?

Cheers,
Rusty.
