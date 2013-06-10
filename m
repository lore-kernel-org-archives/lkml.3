Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3FJPqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:46:39 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45517 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3FJPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:46:38 -0400
Date: Mon, 10 Jun 2013 16:46:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 00/10] regulator: ab8500-ext: Refactorings
Message-ID: <20130610154633.GL20297@gmail.com>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdbygDNdsO=EzigPiBSnMmF-NVnF95HeBBavkry93i+ubQ@mail.gmail.com>
 <20130610151208.GK20297@gmail.com>
 <20130610152507.GF1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130610152507.GF1403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, Mark Brown wrote:

> On Mon, Jun 10, 2013 at 04:12:08PM +0100, Lee Jones wrote:
> 
> > The 'ux500: regulator_supply' patch, relies on the 'regulator:
> > supply_name' one however. Mark has taken two of them, I don't know why
> > the others were missed/intentionally left.
> 
> > Mark, was there a reason for this?
> 
> IIRC they were more involved and since you decided to pick a random
> e-mail address to send them to that goes nowhere near the mailboxes I
> use for upstream they're not going to bubble up particularly quickly.

Not as random as you might think.

I knew you'd left your old place, so I did:

  `git log --author="Mark Brown" --format=%ae next/master | uniq -c | head`

... to see what you were using most recently. I recieved:

     67 broonie@linaro.org
      1 broonie@kernel.org
      1 broonie@linaro.org
     59 broonie@opensource.wolfsonmicro.com
     28 broonie@sirena.org.uk
    763 broonie@opensource.wolfsonmicro.com
      1 broonie@sirena.org.uk
    428 broonie@opensource.wolfsonmicro.com
      1 broonie@sirena.org.uk
     23 broonie@opensource.wolfsonmicro.com

... hence why I used your linaro address.

I'll send it out again to your kernel.org one if it make you happy. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
