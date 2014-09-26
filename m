Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaIZTGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:06:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaIZTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:06:42 -0400
Date: Fri, 26 Sep 2014 15:06:35 -0400 (EDT)
Message-Id: <20140926.150635.2121424504995454707.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        dborkman@redhat.com, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, pablo@netfilter.org,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 net-next 00/11] eBPF syscall, verifier, testsuite
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411715827-10430-1-git-send-email-ast@plumgrid.com>
References: <1411715827-10430-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Sep 2014 12:06:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Fri, 26 Sep 2014 00:16:56 -0700

> v14 -> v15:
> - got rid of macros with hidden control flow (suggested by David)
>   replaced macro with explicit goto or return and simplified
>   where possible (affected patches #9 and #10)
> - rebased, retested

Series applied to net-next, thanks.
