Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbaLLSq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:46:29 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:20386 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932399AbaLLSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:46:27 -0500
X-IronPort-AV: E=Sophos;i="5.07,565,1413237600"; 
   d="scan'208";a="113035375"
Date: Fri, 12 Dec 2014 19:46:24 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
In-Reply-To: <548B0A29.8050503@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1412121945580.2059@localhost6.localdomain6>
References: <5480DA32.8000201@users.sourceforge.net> <20141209.145447.2234157264287438778.davem@davemloft.net> <548A92E2.8090304@users.sourceforge.net> <20141212.092950.1840808214143867233.davem@davemloft.net> <548B0A29.8050503@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I hope that a bit more constructive suggestions will be contributed by
> involved
> software developers around the affected source code. Now it seems
> that a small code clean-up becomes a more challenging development task.

This is often the case.  Doing something half way is not useful.

julia
