Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3FYLR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:17:26 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:45641 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751829Ab3FYLRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:17:25 -0400
Date: Tue, 25 Jun 2013 19:17:18 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/6] Various ux500 crypto updates
Message-ID: <20130625111718.GA18551@gondor.apana.org.au>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdYgZ5ZSwDBfV8FRRqGcv09JiFyNq18vqO_dbxbhJ6_x4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYgZ5ZSwDBfV8FRRqGcv09JiFyNq18vqO_dbxbhJ6_x4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:20:50AM +0200, Linus Walleij wrote:
> On Tue, Jun 25, 2013 at 10:54 AM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > these are some fixes to issue pointed out by sparse and dmaengine API
> > udpates on the recently enabled ux500 hw crypto drivers.
> 
> The series:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> > These are based on recent linux-next, and can probably be applied on an
> > architecture specific branch with your ack, or just skip to the next
> > merge window.
> 
> I think these depend on the DMA40 fixes that reside in the ARM SoC
> tree. If I get Herbert's ACK I can queue them.

Sure,

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
