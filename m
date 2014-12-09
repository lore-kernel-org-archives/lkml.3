Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaLIVm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:42:56 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63383 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaLIVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:42:54 -0500
Message-ID: <1418161372.27198.11.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] fix suspicious rcu_dereference_check in
 net/sched/sch_fq_codel.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Tue, 09 Dec 2014 13:42:52 -0800
In-Reply-To: <58905.1418159750@turing-police.cc.vt.edu>
References: <58905.1418159750@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 16:15 -0500, Valdis Kletnieks wrote:
> commit 46e5da40ae (net: qdisc: use rcu prefix and silence
>  sparse warnings) triggers a spurious warning:
> 
> net/sched/sch_fq_codel.c:97 suspicious rcu_dereference_check() usage!
> 
> The code should be using the _bh variant of rcu_dereference.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> ---
>  net/sched/sch_fq_codel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


