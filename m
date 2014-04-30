Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbaD3Psm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:48:42 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49869 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759371AbaD3Psj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:48:39 -0400
Message-ID: <1398872915.29914.164.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: Allow tc changes in user namespaces
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 30 Apr 2014 08:48:35 -0700
In-Reply-To: <1398871543-8435-1-git-send-email-stgraber@ubuntu.com>
References: <1398871543-8435-1-git-send-email-stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 11:25 -0400, Stéphane Graber wrote:
> This switches a few remaining capable(CAP_NET_ADMIN) to ns_capable so
> that root in a user namespace may set tc rules inside that namespace.
> 
> Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
> ---
>  net/sched/cls_api.c | 3 ++-
>  net/sched/sch_api.c | 8 +++++---
>  2 files changed, 7 insertions(+), 4 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>


