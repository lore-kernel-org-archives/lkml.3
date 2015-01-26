Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbbAZEkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:40:36 -0500
Received: from mail.eperm.de ([89.247.134.16]:60140 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbbAZEkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:40:33 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 05:40:31 +0100
Message-ID: <3191384.X2lutdSA8X@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150126043733.GA20984@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de> <13294516.zBBDkdi9pn@tachyon.chronox.de> <20150126043733.GA20984@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. Januar 2015, 15:37:33 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jan 26, 2015 at 05:35:07AM +0100, Stephan Mueller wrote:
> > It seems I have misunderstood you in the last discussion.
> 
> I thought you were limiting the receive SGL by ALG_MAX_PAGES rather
> than a single IOV entry.

Ok, I will do that. Sorry for the misunderstanding.
> 
> Cheers,


-- 
Ciao
Stephan
