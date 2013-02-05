Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3BENDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:03:11 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64950 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3BENDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:03:08 -0500
Date: Tue, 5 Feb 2013 13:03:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
Message-ID: <20130205130302.GA2042@gmail.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
 <1359978868-28736-6-git-send-email-lee.jones@linaro.org>
 <20130204193737.GU4720@opensource.wolfsonmicro.com>
 <CACRpkdYWZOa=bbJYpG7owxVJXxPq5sx7jHmo5UpRe8pmPGYKMQ@mail.gmail.com>
 <20130205120134.GY4720@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130205120134.GY4720@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2013, Mark Brown wrote:

> On Mon, Feb 04, 2013 at 10:21:36PM +0100, Linus Walleij wrote:
> 
> > What is needed is some way to model that
> > electronic relationship into both the regulator
> > and clock subsystems (Ulf Hansson is working on
> > the ABx500 clocks as we speak.)
> 
> > Maybe the actual place to have it would be
> > somewhere like drivers/mfd/ab8500-core.c.
> 
> > Have you seen similar stuff in other PMICs?
> 
> Yes, it's fairly common to at least have hardware enable signals.  If
> what was going on was actually understood by the driver in some way it
> might be better but right now...  Especially in a series like this it's
> really bad to just see loads of patches which boil down to "change the
> semi-documented magic value" - this just makes the series depressing to
> read.

I'm currently working on making _slightly_ less depressing - bear with. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
