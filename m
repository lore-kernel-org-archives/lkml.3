Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab3FMXDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:03:08 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34718 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab3FMXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:03:06 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-samsung-soc@vger.kernel.org,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org, thomas.abraham@linaro.org
Subject: Re: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Fri, 14 Jun 2013 01:03:03 +0200
Message-ID: <2614957.8jBPZazWeB@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <15dd01ce6887$f3d6d720$db848560$%kim@samsung.com>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org> <9948950.GZ51yJYkxQ@flatron> <15dd01ce6887$f3d6d720$db848560$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 of June 2013 07:47:15 Kukjin Kim wrote:
> Tomasz Figa wrote:
> > On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
> > > It's convenient if get_maintainer suggests sending samsung/exynos
> > > pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry
> > > for
> > > that.
> > 
> > Well, if we are already at it, we could list the actual maintainers of
> > the driver.
> > 
> > The original maintainer was Thomas Abraham <thomas.abraham@linaro.org>
> 
> Should be original author?! I think, original maintainer was/is Linus
> Walleij.

Linus is the maintainer of the pin control subsystem. In addition drivers 
can have their own maintainers, but of course they are lower in the 
hierarchy than subsystem maintainers.

> Let's see, probably original author should have some knowledge for it
> but the meaning of the maintainer is different. Of course, would be
> helpful if original author could review and maintain...

Maintainer is the person who takes care of the code, including testing, 
fixes, review of patches, but also development as well to keep the driver 
up to date with core code, improve things, add support for new hardware, 
etc.

Originally Thomas Abraham was the person doing it for this driver. At 
least I remember, he was the person who reviewed and acked my patches when 
I started my work on improving this driver.

Later on I took over most of those tasks and I've been doing so ever since 
that time.

Best regards,
Tomasz

