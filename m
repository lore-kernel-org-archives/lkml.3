Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3CUSSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:18:47 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:61646 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3CUSSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130321095415.GB26931@gondor.apana.org.au>
References: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
	<20130321095415.GB26931@gondor.apana.org.au>
Date: Thu, 21 Mar 2013 19:18:45 +0100
Message-ID: <CACRpkdbqhjm9=o5GG5Anqa5bRFL5cTdrXD=ZBd=7gntvoSSaCg@mail.gmail.com>
Subject: Re: [PATCH] crypto: replace kmalloc and then memcpy with kmemdup
From: Linus Walleij <linus.walleij@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>, linux-crypto@vger.kernel.org,
        davem@davemloft.net, andreas.westin@stericsson.com, arnd@arndb.de,
        rubini@unipv.it, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:54 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Mon, Mar 11, 2013 at 12:48:10PM +0200, Mihnea Dobrescu-Balaur wrote:
>> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
>
> Patch applied.  Thanks.

Acked-by: Linus Walleij <linus.walleij@linaro.org> FWIW, I tried to get the
people involved with the code to ACK but somehow they must've missed it.

Thanks,
Linus Walleij
