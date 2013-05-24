Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3EXIYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:24:36 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:46705 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab3EXIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:24:33 -0400
Date: Fri, 24 May 2013 09:24:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] ARM: ux500: Only configure wake-up reasons on ux500
 based platforms
Message-ID: <20130524082428.GO22683@gmail.com>
References: <1368702935-25599-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdZjC7nFxsWkED6FvCOxdA1oQVuB+Tz8DZWM+iQDi6zjWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZjC7nFxsWkED6FvCOxdA1oQVuB+Tz8DZWM+iQDi6zjWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013, Linus Walleij wrote:

> On Thu, May 16, 2013 at 1:15 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Multiplatform calls all enabled platforms' initcalls. In the
> > ux500_idle_init() initcall we call into the DBx500-PRCMU which in turn
> > executes some ux500 specific register reads/writes. When running on
> > some !ux500 platforms this ends up causing a kernel Oops. This patch
> > ensures the PRCMU call is only invoked when running on ux500 based
> > platforms.
> >
> > Reported-by: Rob Herring <rob.herring@calxeda.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Patch applied for ux500 fixes.
> 
> Hm, again and again I get so confused by this, don't you say
> "wakeup CAUSE" rather than "wakeup REASON"?
> 
> Maybe I don't know the anglo saxon well enough...

The words 'cause' and 'reason' are fairly synonymous and are
interchangeable in a great many situations. You have to be an English
literary Nazi to care enough to work out the semantics, which in case
you hadn't noticed, I'm not. :)

But, credit where credit's due, in this particular instance you are
correct. Feel free to fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
