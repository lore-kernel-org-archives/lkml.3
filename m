Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935053AbaLLPbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:31:11 -0500
Received: from mout.web.de ([212.227.15.14]:56857 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934903AbaLLPbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:31:06 -0500
Message-ID: <548B0A29.8050503@users.sourceforge.net>
Date: Fri, 12 Dec 2014 16:30:49 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
References: <5480DA32.8000201@users.sourceforge.net>	<20141209.145447.2234157264287438778.davem@davemloft.net>	<548A92E2.8090304@users.sourceforge.net> <20141212.092950.1840808214143867233.davem@davemloft.net>
In-Reply-To: <20141212.092950.1840808214143867233.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:1+XCeCaSGxWZzvILIffVTwH0qddC0cscK+K+YRCiyvq8DhbfJKQ
 XNYyVgpIILfUGL97ekyXrMzVZp3NN6WMqejfMzuGoR86cDnhlUB9iFILSndIXJTvabGjNTi
 3g2T51XqFrGmRew6+a58igmd6g8tjZ/WUJVkZ4W5tE76h7yic4xX0gOICfxYp6VywxpJgD1
 NQ8YMCq0IF3gqCCHMCMTQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I gave you very concrete feedback, I said exactly that I don't want
> error pointers left in data structure members.

I find that your critique affects the proposed update steps four to six,
doesn't it?
Are the other steps acceptable in principle?


> I cannot describe my requirements any more precisely than that.

I hope that a bit more constructive suggestions will be contributed by
involved
software developers around the affected source code. Now it seems
that a small code clean-up becomes a more challenging development task.

How do you prefer to redesign corresponding data structures eventually?

Regards,
Markus
