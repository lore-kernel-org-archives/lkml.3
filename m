Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3GWMjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:39:10 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45025 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3GWMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130723095513.19b9638ab4a19157e9834dcf@canb.auug.org.au>
References: <20130723095513.19b9638ab4a19157e9834dcf@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 23 Jul 2013 13:38:45 +0100
X-Google-Sender-Auth: 1D4QUlO2oFV50o1oGLVGChvr4SQ
Message-ID: <CACxGe6tjrFG1aLc9Scmmuunjb9hTm5vyH6LqXiys8484YY=Zzw@mail.gmail.com>
Subject: Re: linux-next: status of various trees
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:55 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Currently linux-next has the following gpio trees:
>
> gpio-current    git://git.secretlab.ca/git/linux-2.6#gpio/merge
> gpio            git://git.secretlab.ca/git/linux-2.6#gpio/next
> gpio-lw         git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git#for-next
>
> Given commit a0062d4e3a0a ("MAINTAINERS: Remove Grant Likely") in the
> devicetree-current tree today, should I remove the first two and rename
> the third to be just "gpio"?  (And does Linus have an alternative
> "current" tree?)
>
> I also have the irqdomain tree:
>
> irqdomain       git://git.secretlab.ca/git/linux-2.6.git#irqdomain/next
>
> Should I remove that?  And is there going to be an alternative?
>
> And for spi, I have:
>
> spi             git://git.secretlab.ca/git/linux-2.6#spi/next
> spi-mb          git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git#for-next
>
> again, should I remove the first and rename the second?

Yes on all of the above. Thanks.

g.
