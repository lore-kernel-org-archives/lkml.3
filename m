Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbbAEVzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:55:33 -0500
Received: from mout.web.de ([212.227.17.12]:51278 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbbAEVzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:55:32 -0500
Message-ID: <54AB0844.5090405@users.sourceforge.net>
Date: Mon, 05 Jan 2015 22:55:16 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] fs/9p: Deletion of unnecessary checks before the
 function call "p9_client_clunk"
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net> <54A06AB9.4020505@users.sourceforge.net> <20150105112206.GC15033@mwanda> <54AB02F3.5020308@users.sourceforge.net> <alpine.DEB.2.02.1501052239290.2025@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1501052239290.2025@localhost6.localdomain6>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:gGRwlDOQFS42f9Pe4zYoLjWQqyiqLQt08qqaAzwNgGVhap2XMP7
 YY2TYQqnZVBjo8xXX3ohlNO+TTOx7RUfgC6U1ytcGS62hA7Zgzg05UsCC29c7c2L3yeXQeD
 xclMob4jry9uHrcn0tU/6AROeH/2Td8CxYNbefl0av8g/hfqP05p14S3HrwlwpIHM4he3Co
 nxvFwAq+7cOvrX1X2pLLQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/net/9p/client.c?id=d8282ea05ad119247122de23db7d48ad6098cfa2#n1448
>> http://lxr.free-electrons.com/source/net/9p/client.c#L1448
> 
> What do you mean by "work in principle"?

If I do not stumble on an unexpected name space issue from my static source
analysis again, then I would see the linked function as relevant here.
Its implementation provides a clear input parameter validation.


> But you don't want to do a dump_stack for no reason.  That would at best
> be very misleading, and I would imagine be quite expensive.

The error response is clear. Are any software developments efforts expected
to clean-up the call stack for unwanted null pointers even more?

Regards,
Markus
