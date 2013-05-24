Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab3EXIcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:32:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64938 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070Ab3EXIcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:32:36 -0400
Date: Fri, 24 May 2013 09:32:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the driver
Message-ID: <20130524083231.GQ22683@gmail.com>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
 <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZHT0g_Agtug6jC3rU+DYKOpmwqZ9eQAkRGRw5Kj0wW4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZHT0g_Agtug6jC3rU+DYKOpmwqZ9eQAkRGRw5Kj0wW4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013, Linus Walleij wrote:

> On Thu, May 16, 2013 at 1:27 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > By providing an OF match table with a suitable compatible string, we
> > can ensure the ux500-crypt driver is probed by supplying an associated
> > DT node in a given platform's Device Tree.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Herbert, can I have your ACK on patch 5 & 6 in this series to take it
> through the ARM SoC tree?

Right, there are no bindings, so they don't need a document.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
