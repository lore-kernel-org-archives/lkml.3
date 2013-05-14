Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3ENItB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:49:01 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34290 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3ENIs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:48:58 -0400
Date: Tue, 14 May 2013 09:48:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 6/9] ARM: ux500: Provide device enumeration number suffix
 for SMSC911x
Message-ID: <20130514084854.GF3297@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
 <1368019749-19455-7-git-send-email-lee.jones@linaro.org>
 <CACRpkdYz0HcdBovoJu6O-4QyRbXz93MaeWwAwCohbE8rv=8O7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYz0HcdBovoJu6O-4QyRbXz93MaeWwAwCohbE8rv=8O7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013, Linus Walleij wrote:

> On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > First Ethernet device has a ".0" appended onto the device name. It
> > appears that we need this in order to obtain the correct clock.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> > -       OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x", NULL),
> > +       OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x.0", NULL),
> 
> I guess what you want to say in the commit message is that
> on a non-DT boot the ethernet will be named "smsc911x.0"
> and since the clocks are not converted to device tree these
> names need to be matched when providing the name from
> auxdata.
> 
> Edited the commit message and applied!

Thanks for the effort. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
