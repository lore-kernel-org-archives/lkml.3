Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaLCNZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:25:13 -0500
Received: from mout.web.de ([212.227.17.11]:61422 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaLCNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:25:10 -0500
Message-ID: <547F0F2A.3060708@users.sourceforge.net>
Date: Wed, 03 Dec 2014 14:24:58 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Julia Lawall <julia.lawall@lip6.fr>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, backports@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net> <20141203124511.GR5048@mwanda> <547F0977.7090908@users.sourceforge.net> <20141203132002.GT5048@mwanda>
In-Reply-To: <20141203132002.GT5048@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:T2Ayi2DMoZrEjYZ5/wBrMuS4DPllzAVzrT6yixEgv/tdcMXF/0d
 /EwGnCpqamBJQXBn6mj/IqG+Vo485aieiAoWLLp68yPgl7ybitG7k0y7E7Dj9GAnNAWajDX
 t6yfTWjIAT/urRFFJRsRu2vaqn+p1pjTop9YD8k59ku8S6JWei10bj6eJyjVStzgXNmYNKS
 ZIg+cVs5kEAPZ0R+mzdtg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry.  I misread your email.  If the code looks like this:
> 
> 	foo = kmalloc();
> 	if (!foo)
> 		goto kmalloc_failed;
> 
> The "kmalloc_failed" doesn't add any information.

I find that this such a name approach would fit to your
expectation of a source-oriented labeling of these identifiers.


> We can see that kmalloc failed from the context.

Which name pattern do you find more appropriate in such
an use case?

Regards,
Markus
