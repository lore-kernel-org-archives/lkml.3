Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588Ab3DBJY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:24:56 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48314 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3DBJYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:24:53 -0400
Date: Tue, 2 Apr 2013 10:24:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ux500: update V-INTCORE constraints
Message-ID: <20130402092446.GB4375@gmail.com>
References: <1364397694-14126-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdYgCxf9R1aU2QdPUBxErhK=E2tM=6L-yMLA_L3+ntj3nQ@mail.gmail.com>
 <20130402083829.GB23065@opensource.wolfsonmicro.com>
 <20130402084446.GA6850@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130402084446.GA6850@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I know that Lee's been sending off a large set of regulator patches
> > > lately, some include alterations to this platform config.
> > 
> > > Maybe it's better to take this patch into the regulator tree if these
> > > machine configs will come in that way? Also like Lee to have a
> > > look at this...
> > 
> > If it's touching the board constraints it's likely to have conflicts
> > with Lee's stuff, yes.
> 
> Lee's patches are on -next

Not all of them are on -next, but all are on the MLs.

I'm currently fixing up some of Mark's review comments in order to
re-submit the remainder.

> and should not conflict with this one
> (tested again on today's tree), but it may be nice anyway to have this
> in the regulator framework with the others.

> Mark, would you consider taking this one in your tree?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
