Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaIPVtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:49:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaIPVtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:49:04 -0400
Date: Tue, 16 Sep 2014 17:49:01 -0400 (EDT)
Message-Id: <20140916.174901.2174503796369572537.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        dborkman@redhat.com, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, pablo@netfilter.org,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 net-next 03/11] bpf: add
 lookup/update/delete/iterate methods to BPF maps
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuzy0Hvjr0f4XBrH+FAxaKD7aijnYzDe3-MPrGWe6+MD4Q@mail.gmail.com>
References: <CAMEtUuxp6709mdygiQyCqwjv-0kF-CbNOzCCZmKw_mUckF4NZA@mail.gmail.com>
	<20140916.165452.1747695341192703967.davem@davemloft.net>
	<CAMEtUuzy0Hvjr0f4XBrH+FAxaKD7aijnYzDe3-MPrGWe6+MD4Q@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 14:49:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 16 Sep 2014 14:23:27 -0700

> no compat layer and type checking will be done
> by syscall wrappers. Ok?

Why are you against using strong typing just for everything other
than the user pointer blobs?

I don't understand the resistence to my suggestion to just use
aligned_u64 instead of "void __user *" in the union members.
