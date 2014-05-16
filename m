Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaEPX02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:26:28 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61798 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaEPX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:26:27 -0400
Date: Fri, 16 May 2014 16:26:35 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        alexandre.belloni@free-electrons.com,
        boris.brezillon@free-electrons.com, linus.walleij@linaro.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.16 #1
Message-ID: <20140516232635.GB6423@quad.lixom.net>
References: <1399484042-27432-1-git-send-email-nicolas.ferre@atmel.com>
 <536A6FD7.40402@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A6FD7.40402@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 07:39:35PM +0200, Nicolas Ferre wrote:
> On 07/05/2014 19:34, Nicolas Ferre :
> > Arnd, Olof, Kevin,
> > 
> > This is the first cleanup pull-request for 3.16. It is pretty big because it
> > integrates the work from Boris about CCF and Alexandre about IIO/ADC. I
> > integrated them in this cleanup topic because they both touch the core at91
> > code, the clk and IIO drivers as well as the DT. The concerned maintainers
> > added their tags.
> > 
> > The patch by Linus is a move of at91 specific GPIO definitions out of the
> > include/mach directory which is an step towards single zImage.
> > 
> > Thanks, best regards,
> > 
> > The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:
> > 
> >   Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://github.com/at91linux/linux-at91.git tags/at91-cleanup
> 
> There is a little conflict with at91-3.16-dt that you already pulled in
> arm-soc: here is the branch that resolves it:
> 
> https://github.com/at91linux/linux-at91/commits/at91-3.16-resolved

That resolution looks odd. Why is one clock under clocks { } and two of them
are at the top level? Shouldn't they all be under the clocks subnode?

I've merged in now with your resolution, but I think this needs revisiting.


-Olof
