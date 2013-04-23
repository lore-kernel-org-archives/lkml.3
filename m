Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3DWPKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:10:10 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43787 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab3DWPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:10:04 -0400
Date: Tue, 23 Apr 2013 16:09:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: Over-ride TCDM size when booting the DB8540
 platform
Message-ID: <20130423150959.GA17416@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
 <1364908916-29803-5-git-send-email-lee.jones@linaro.org>
 <CACRpkdbh-DJti2ny=uBe-b_vGkQBNL=emMuZ6+_cE5jvRsA4sA@mail.gmail.com>
 <20130404073340.GA6892@gmail.com>
 <CACRpkdYLJyvCK33pAHeOkXfBOiPJGAZ9bV+s-cJanfOXz+VTOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYLJyvCK33pAHeOkXfBOiPJGAZ9bV+s-cJanfOXz+VTOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 4, 2013 at 9:33 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The PRCMU's Tightly Coupled Data Memory on the DB8540 platform is
> > 8kB larger than it's predecessor's. We need to reflect that in its
> > Device Tree. By re-specifying the address and size of the device
> > we effectively over-ride the previous values with more accurate
> > ones.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> As mentioned this patch does not apply. Some whitespace trouble.
> 
> And please squash it into the patch adding the ccu8540, 3/9.

I'm not sure what's going on with all this whitespace stuff, my branch
looks fine. Any chance I can just supply you with a branch to take
instead?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
