Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaCKCeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:34:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57539 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbaCKCeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:34:06 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140310.222449.561233409099006984.davem@davemloft.net>
References: <1394431444-6987-2-git-send-email-ast@plumgrid.com> <20140310.215104.2095195123238829635.davem@davemloft.net> <CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com> <20140310.222449.561233409099006984.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter and converter
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 10 Mar 2014 19:33:03 -0700
To: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org
CC: ast@plumgrid.com, dborkman@redhat.com, mingo@kernel.org, wad@chromium.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, hagen@jauu.net,
        jesse@nicira.com, tglx@linutronix.de, edumazet@google.com,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <3ee8da10-166e-45c1-925a-f089085fdff4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not for variables? It makes a lot of sense of nothing else to avoid the confusion that invariably happens when someone decides to introduce the value 2 or -1 to an existing variable (and yes, thus has happened a number of times.)

Not to mention they take a single byte rather than four for an int if stored in memory.

On March 10, 2014 7:24:49 PM PDT, David Miller <davem@davemloft.net> wrote:
>From: Linus Torvalds <torvalds@linux-foundation.org>
>Date: Mon, 10 Mar 2014 19:02:18 -0700
>
>> I would generally suggest that people only use "bool" for function
>> return types, and absolutely nothing else. Seriously.
>
>I think it makes sense for function arguments too.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
