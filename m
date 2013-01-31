Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3AaOHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:07:43 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32938 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3AaOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:07:41 -0500
Date: Thu, 31 Jan 2013 14:07:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ASoC: Ux500: Fix build error pertaining to missing
 include file
Message-ID: <20130131140735.GD2042@gmail.com>
References: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
 <20130131123744.GG11078@opensource.wolfsonmicro.com>
 <20130131130340.GB2042@gmail.com>
 <20130131130631.GA12824@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130131130631.GA12824@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Mark Brown wrote:

> On Thu, Jan 31, 2013 at 01:03:40PM +0000, Lee Jones wrote:
> > On Thu, 31 Jan 2013, Mark Brown wrote:
> > > On Thu, Jan 31, 2013 at 12:34:00PM +0000, Lee Jones wrote:
> 
> > > > Some compilers complain when building sound for MOP500:
> 
> > > > sound/soc/ux500/mop500.c:27:27:
> > > >         fatal error: mop500_ab8500.h: No such file or directory
> 
> > > Should be kernel version dependant I expect...
> 
> > What do you mean?
> 
> I'm a bit surprised the compiler would change something like that, I'd
> expect it to be more the build system.

You've lost me.

When I compile this file it succeeds. When the person who reported
this bug compiles, it fails with the error above.

mop500_ab8500.h is actually in the same directory as the file
including it, so it should by rights be encapsulated in "" and not <>,
right?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
