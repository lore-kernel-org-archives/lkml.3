Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaLIT50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:57:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38139 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaLIT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:57:24 -0500
Date: Tue, 09 Dec 2014 14:57:19 -0500 (EST)
Message-Id: <20141209.145719.481232465007794033.davem@davemloft.net>
To: joe@perches.com
Cc: eric.dumazet@gmail.com, alexei.starovoitov@gmail.com,
        lambert.quentin@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: bpf_jit_comp: Remove inline from static function
 definitions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417741284.2721.26.camel@perches.com>
References: <CAADnVQ+3jiYOYReRLPUsFeG1p66ezo-TXBLX3BGQQh7V8QX0tQ@mail.gmail.com>
	<1417740382.22424.40.camel@edumazet-glaptop2.roam.corp.google.com>
	<1417741284.2721.26.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 11:57:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 04 Dec 2014 17:01:24 -0800

> Let the compiler decide instead.
> 
> No change in object size x86-64 -O2 no profiling
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
