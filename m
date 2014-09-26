Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaIZEk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:40:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaIZEk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:40:27 -0400
Date: Fri, 26 Sep 2014 00:40:24 -0400 (EDT)
Message-Id: <20140926.004024.1179261758092351350.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        dborkman@redhat.com, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, pablo@netfilter.org,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 net-next 10/11] bpf: verifier (add verifier core)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411344411-3824-11-git-send-email-ast@plumgrid.com>
References: <1411344411-3824-1-git-send-email-ast@plumgrid.com>
	<1411344411-3824-11-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Sep 2014 21:40:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Sun, 21 Sep 2014 17:06:50 -0700

> +#define _(OP) ({ int ret = (OP); if (ret < 0) return ret; })

Please do not hide program control flow inside of a macro.

Thank you.
