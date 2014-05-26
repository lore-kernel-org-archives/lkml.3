Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaEZFoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:44:30 -0400
Received: from mail.eperm.de ([89.247.134.16]:43898 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaEZFo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:44:29 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com, joe@perches.com
Subject: Re: [PATCH v7 1/6] SP800-90A Deterministic Random Bit Generator
Date: Mon, 26 May 2014 07:44:15 +0200
Message-ID: <2006828.NMLXLGt5ck@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140523211007.GA20955@gondor.apana.org.au>
References: <20140523211007.GA20955@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 24. Mai 2014, 05:10:07 schrieb Herbert Xu:

Hi Herbert,

> Stephan Mueller <smueller@chronox.de> wrote:
> > +       memset(&drbg_algs[i], 0, sizeof(struct crypto_alg));
> > +       if (pr) {
> > +               memcpy(drbg_algs[i].cra_name, "drbg(pr(", 8);
> > +               memcpy(drbg_algs[i].cra_driver_name, "drbg_pr_", 8);
> > +               pos = 8;
> 
> You shouldn't use the brackets here since this not a real template.
> Just use one name for both cra_name and cra_driver_name.

Thanks for the hint: I would use the name specified for cra_driver_name also 
for cra_name
> 
> Cheers,


Ciao
Stephan
-- 
| Cui bono? |
