Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234Ab3DBIpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:45:02 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52434 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab3DBIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:44:59 -0400
Date: Tue, 2 Apr 2013 10:44:46 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ux500: update V-INTCORE constraints
Message-ID: <20130402084446.GA6850@balto.lan>
References: <1364397694-14126-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdYgCxf9R1aU2QdPUBxErhK=E2tM=6L-yMLA_L3+ntj3nQ@mail.gmail.com>
 <20130402083829.GB23065@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402083829.GB23065@opensource.wolfsonmicro.com>
X-Operating-System: Linux balto 3.9.0-rc3-00140-g10b3866-dirty x86_64
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Linus,

On Tue, Apr 02, 2013 at 09:38:30AM +0100, Mark Brown wrote:
> On Tue, Apr 02, 2013 at 10:26:12AM +0200, Linus Walleij wrote:
> 
> > I know that Lee's been sending off a large set of regulator patches
> > lately, some include alterations to this platform config.
> 
> > Maybe it's better to take this patch into the regulator tree if these
> > machine configs will come in that way? Also like Lee to have a
> > look at this...
> 
> If it's touching the board constraints it's likely to have conflicts
> with Lee's stuff, yes.

Lee's patches are on -next and should not conflict with this one
(tested again on today's tree), but it may be nice anyway to have this
in the regulator framework with the others.

Mark, would you consider taking this one in your tree?

Thanks,
Fabio

-- 
Fabio Baltieri
