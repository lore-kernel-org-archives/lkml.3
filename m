Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3EQICw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:02:52 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55113 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3EQICt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:02:49 -0400
Date: Fri, 17 May 2013 10:02:39 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ARM: ux500: update MSP1 pinctrl defintions
Message-ID: <20130517080239.GA26583@balto.lan>
References: <1368004193-21213-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdZj6r3=fo=72PDshHbL7oHxb6H6uGeGvRyb2+uMjoAvUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZj6r3=fo=72PDshHbL7oHxb6H6uGeGvRyb2+uMjoAvUg@mail.gmail.com>
X-Operating-System: Linux balto 3.9.0-10518-gd7ab730 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 09:35:17PM +0200, Linus Walleij wrote:
> On Wed, May 8, 2013 at 11:09 AM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > Update MSP1 pinctrl definitions in mop500_family_pinmap by removing
> > sleep state and setting default ones as pin hogs, as those are used by
> > both ux500-msp-i2s.1 and ux500-msp-i2s.3.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> Applied to my ux500-pinctrl branch.

Thanks Linus,

This one was actually sort-of related to the ASoC patch to drop sleep
pin state control from the ux500 ASoC driver.  Would you be able to
check that one too?

The subject is:
  [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support

There are no dependency issues by applying this and the other in
different trees, but I'd like to close the discussion on the other one.

Thanks,
Fabio

-- 
Fabio Baltieri
