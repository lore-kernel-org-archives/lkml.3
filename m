Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab3DBJeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:34:19 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42812 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3DBJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:34:17 -0400
Date: Tue, 2 Apr 2013 11:34:06 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH RESEND] ARM: ux500: update V-INTCORE constraints
Message-ID: <20130402093406.GA16789@balto.lan>
References: <20130402084658.GD23065@opensource.wolfsonmicro.com>
 <1364892716-25505-1-git-send-email-fabio.baltieri@linaro.org>
 <20130402092305.GA4375@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402092305.GA4375@gmail.com>
X-Operating-System: Linux balto 3.9.0-rc3-00140-g10b3866-dirty x86_64
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 10:23:05AM +0100, Lee Jones wrote:
> On Tue, 02 Apr 2013, Fabio Baltieri wrote:
> 
> > Update V-INTCORE regulator constraints to allow voltage and
> > configuration changes from consumer drivers.
> > 
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >  arch/arm/mach-ux500/board-mop500-regulators.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> I already have this queued.

Ok, that was part of another yet to be merged series.

Mark, please ignore this one, sorry for the added noise.

Fabio

-- 
Fabio Baltieri
