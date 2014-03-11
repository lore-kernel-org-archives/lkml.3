Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaCKCYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:24:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaCKCYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:24:53 -0400
Date: Mon, 10 Mar 2014 22:24:49 -0400 (EDT)
Message-Id: <20140310.222449.561233409099006984.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: ast@plumgrid.com, dborkman@redhat.com, mingo@kernel.org, wad@chromium.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        hagen@jauu.net, jesse@nicira.com, tglx@linutronix.de,
        edumazet@google.com, akpm@linux-foundation.org, fweisbec@gmail.com,
        acme@infradead.org, penberg@iki.fi, arjan@infradead.org,
        hch@infradead.org, xemul@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com>
References: <1394431444-6987-2-git-send-email-ast@plumgrid.com>
	<20140310.215104.2095195123238829635.davem@davemloft.net>
	<CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 19:24:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Mar 2014 19:02:18 -0700

> I would generally suggest that people only use "bool" for function
> return types, and absolutely nothing else. Seriously.

I think it makes sense for function arguments too.
