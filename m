Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaCKCjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:39:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49678 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaCKCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:39:13 -0400
Date: Mon, 10 Mar 2014 22:39:10 -0400 (EDT)
Message-Id: <20140310.223910.1009590531824384809.davem@davemloft.net>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, ast@plumgrid.com, dborkman@redhat.com,
        mingo@kernel.org, wad@chromium.org, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, hagen@jauu.net, jesse@nicira.com,
        tglx@linutronix.de, edumazet@google.com, akpm@linux-foundation.org,
        fweisbec@gmail.com, acme@infradead.org, penberg@iki.fi,
        arjan@infradead.org, hch@infradead.org, xemul@parallels.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: David Miller <davem@davemloft.net>
In-Reply-To: <3ee8da10-166e-45c1-925a-f089085fdff4@email.android.com>
References: <CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com>
	<20140310.222449.561233409099006984.davem@davemloft.net>
	<3ee8da10-166e-45c1-925a-f089085fdff4@email.android.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 19:39:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 10 Mar 2014 19:33:03 -0700

> Why not for variables? It makes a lot of sense of nothing else to
> avoid the confusion that invariably happens when someone decides to
> introduce the value 2 or -1 to an existing variable (and yes, thus
> has happened a number of times.)
> 
> Not to mention they take a single byte rather than four for an int if stored in memory.

No objection :)
