Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaCNUI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:08:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39255 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbaCNUI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:08:56 -0400
Date: Fri, 14 Mar 2014 16:08:51 -0400 (EDT)
Message-Id: <20140314.160851.1134730495663127657.davem@davemloft.net>
To: ast@plumgrid.com
Cc: pablo@netfilter.org, dborkman@redhat.com, mingo@kernel.org,
        wad@chromium.org, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com, hagen@jauu.net, jesse@nicira.com, tglx@linutronix.de,
        edumazet@google.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v10 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuxd0yd81p7KPxyotMOcOxm3MS4Cj9oguS5QAzfXYChLXQ@mail.gmail.com>
References: <20140314125822.GA16457@localhost>
	<CAMEtUuzqzAHf64DHBao3xKzHdhrp77JEZhe-_c5oC3Vr63QxNA@mail.gmail.com>
	<CAMEtUuxd0yd81p7KPxyotMOcOxm3MS4Cj9oguS5QAzfXYChLXQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Mar 2014 13:08:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Fri, 14 Mar 2014 12:51:17 -0700

> can you please explain why the status of these
> patches is 'deferred' in patchwork ?
> Is it because of bpf vs nft thread?
> I think that's orthogonal.

I do not find it orthogonal, Pablo brings up some very valid points
which I agree with.

EBPF has a lot of the same user side interface limitations that the
existing BPF has, and you refuse to accept this core point Pablo is
making.

That is, that it lacks extensibility, and is too strongly tied to the
implementation.

This is exactly how we run into problems in the future, and you'll be
proposing EBPF_2.0 to address such problems.

I refuse to setup such a situation, and there is absolutely not rush
whatsoever to apply your patches.  We can take our time with this
stuff.
