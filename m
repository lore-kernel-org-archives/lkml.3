Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaKTQBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:01:04 -0500
Received: from mout.web.de ([212.227.15.3]:61279 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaKTQBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:01:01 -0500
Message-ID: <546E1025.3050801@users.sourceforge.net>
Date: Thu, 20 Nov 2014 17:00:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: crypto-drbg: Deletion of unnecessary checks before the function
 call "kzfree"
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546C60E0.1070903@users.sourceforge.net> <20141120143932.GA31996@gondor.apana.org.au>
In-Reply-To: <20141120143932.GA31996@gondor.apana.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:YjEdm84dSkhwmzoH6dpAUejNZcxoCK0dzwG7SVQ2rmz+55gegvs
 WS2P/hvoAq2caPFa8JT/LD0abaqROKih0ZbeUfh2f2kXa7oFtPl2jdqVvFQFZqgH/PSeUjJ
 4+yR0VyFC4/mtRE5qNdNeUvrFgxAtav6f7IXvhbTpUYisP/AbOO4PFX80lnkIGE9XL3kv5l
 f5nz8BYuxUL5oeFQtgamQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry but you're too late as someone else has already fixed this :)

Thanks for your feedback.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/crypto/drbg.c?id=46f64f6ef978dc1f36ebaa50ed79c7c8386711ee

Regards,
Markus

