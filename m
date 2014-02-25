Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaBYOFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:05:22 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:61651 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaBYOFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:05:19 -0500
Date: Tue, 25 Feb 2014 11:05:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Borislav Petkov <bp@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] tools: Unify export.h
Message-ID: <20140225140511.GD5982@ghostprotocols.net>
References: <1393153753-2369-1-git-send-email-bp@alien8.de>
 <87eh2s55tg.fsf@rustcorp.com.au>
 <20140225070020.GA19504@pd.tnic>
 <87eh2r4c2d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh2r4c2d.fsf@rustcorp.com.au>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 25, 2014 at 10:52:02PM +1030, Rusty Russell escreveu:
> Borislav Petkov <bp@suse.de> writes:
> > On Tue, Feb 25, 2014 at 12:09:23PM +1030, Rusty Russell wrote:
> >> Should we get more ambitious and start a fake-kernel/ directory where
> >> we can put userspace equivs/stubs of kernel functionality?
> >
> > Dunno - people like to do that now, it seems.
> >
> > In any case, cleanups and unifications like that would definitely help
> > if we decide to do that because, in this particular example, we have
> > only one export.h to go and fish out.
> 
> Agreed.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

I'm ok with it as well and will stash it in my perf/core branch after
a bit more time for others in the CC list to say something.

- Arnaldo
