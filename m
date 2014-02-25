Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaBYHA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:00:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaBYHAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:00:25 -0500
Date: Tue, 25 Feb 2014 08:00:20 +0100
From: Borislav Petkov <bp@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] tools: Unify export.h
Message-ID: <20140225070020.GA19504@pd.tnic>
References: <1393153753-2369-1-git-send-email-bp@alien8.de>
 <87eh2s55tg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87eh2s55tg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 12:09:23PM +1030, Rusty Russell wrote:
> Should we get more ambitious and start a fake-kernel/ directory where
> we can put userspace equivs/stubs of kernel functionality?

Dunno - people like to do that now, it seems.

In any case, cleanups and unifications like that would definitely help
if we decide to do that because, in this particular example, we have
only one export.h to go and fish out.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
