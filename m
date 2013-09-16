Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3IPHaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:30:08 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:60299 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3IPHaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:30:04 -0400
Date: Mon, 16 Sep 2013 08:30:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Milo Kim <milo.kim@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] Documentation: add LP3943 DT bindings and document
Message-ID: <20130916073000.GA3999@lee--X1>
References: <1378949700-6384-1-git-send-email-milo.kim@ti.com>
 <20130912152455.GN11227@lee--X1>
 <20130915112755.GB9765@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130915112755.GB9765@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Sep 2013, Thierry Reding wrote:

> On Thu, Sep 12, 2013 at 04:24:55PM +0100, Lee Jones wrote:
> > On Thu, 12 Sep 2013, Milo Kim wrote:
> [...]
> > > diff --git a/Documentation/lp3943.txt b/Documentation/lp3943.txt
> > > new file mode 100644
> > > index 0000000..576ebd0
> > > --- /dev/null
> > > +++ b/Documentation/lp3943.txt
> [...]
> > If this stuff is really important (and most of it really isn't), then
> > put it either in the commit log or in the driver.
> 
> I can only speak for myself, but the initial driver commit message is
> about the last place I look for this kind of information. I'd expect it
> to be either somewhere in Documentation/ or in one of the source files.
> In this case I'd probably look at the MFD core driver source file. More
> likely, even, I'd just go google "LP3943" and grab a public datasheet
> from TI where all of this can hopefully be found.

The latter option is the most common. If the datasheet is publicly
available, then there is no rhyme nor reason to put it in the kernel
source too. /Documentation is already overloaded, it would be even
more so if each and every driver residing in the kernel decided to
bulk it up further.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
