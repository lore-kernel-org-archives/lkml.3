Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLEVAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:00:38 -0500
Received: from mout.web.de ([212.227.17.12]:50338 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaLEVAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:00:35 -0500
Message-ID: <54821CEB.2020002@users.sourceforge.net>
Date: Fri, 05 Dec 2014 22:00:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 5/6] net-PPP: Delete an unnecessary assignment in mppe_alloc()
References: <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com> <547C82A6.2030808@users.sourceforge.net> <547CA157.1080401@cogentembedded.com> <5480DA32.8000201@users.sourceforge.net> <5480DDC1.6040101@users.sourceforge.net> <20141205122214.GB4912@mwanda> <5481A8AE.9050506@users.sourceforge.net> <20141205135723.GE4912@mwanda>
In-Reply-To: <20141205135723.GE4912@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:gXhpyL6AT9abYR2mVsXttxasCBSigjiHU0YwsGLQSmIad4oruWi
 xuZqMg2uU6vNTkHdwQ9THcnmaI6GguxJToHZaoS9xfxM1ZrkYnaSnbPaDwg/3904Sr/4QEn
 SbDJAgYA/GX6aonm0wuchp0zed9IzziIpLLXyGDneU3EG+b+lv9pJQO3aQaZCxQmnwx+67G
 vb8uYL3x15aCnWJHFYoIg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> That is true.
> 
> In that case, I misunderstood what you wrote.

I find it a bit interesting how this misunderstanding could happen here somehow.


> Looking at it now, this patch is actually ok.

Does that mean that you would like to add any tag like "Acked-by" or "Reviewed-by"
to any of the proposed six update steps?

Regards,
Markus
