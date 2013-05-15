Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3EOJHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:07:33 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61441 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3EOJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:07:29 -0400
Date: Wed, 15 May 2013 10:07:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 3/9] clk: ux500: Provide device enumeration number suffix
 for SMSC911x
Message-ID: <20130515090721.GB3494@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
 <1368019749-19455-4-git-send-email-lee.jones@linaro.org>
 <20130514155835.10068.93655@quantum>
 <CACRpkdZjvQF9e_isiuUgmcH0RgoGGF=dmg_E7oQjs4oY9f+dFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZjvQF9e_isiuUgmcH0RgoGGF=dmg_E7oQjs4oY9f+dFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Linus Walleij wrote:

> On Tue, May 14, 2013 at 5:58 PM, Mike Turquette <mturquette@linaro.org> wrote:
> > Quoting Lee Jones (2013-05-08 06:29:03)
> >> First Ethernet device has a ".0" appended onto the device name. It
> >> appears that we need this in order to obtain the correct clock.
> >>
> >> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> >> Cc: Mike Turquette <mturquette@linaro.org>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > Looks good to me.  Can I take this into clk-next or are you looking for
> > an Ack?
> 
> You can probably take it through the clk tree, but this series
> deals with regression fixes so it should go into the -rc series
> I think.

That's what Mike has done.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
