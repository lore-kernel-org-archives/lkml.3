Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3BCDgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:36:37 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:44403 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3BCDge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:36:34 -0500
Date: Sat, 2 Feb 2013 19:32:49 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [GIT PULL] power: ab8500-bm: Latest Mainline<->STE delta
 reduction patch-set
Message-ID: <20130203033249.GC25016@lizard.sbx00618.mountca.wayport.net>
References: <20130123113854.GK15873@gmail.com>
 <20130123144441.GN15873@gmail.com>
 <20130131120833.GH5301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130131120833.GH5301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:08:33PM +0000, Lee Jones wrote:
> > Okay, after Linus Walleij's diligent observaions, I have removed all
> > new functionallity related to Deep Debug and will continue to
> > investigate what I need to do in that regard.
> > 
> > In the mean-time, here's the fresh deep-debug:less pull-request:
> > 
> > ----------------------------------------------------------------
> > 
> > The following changes since commit 8fd526fd18233887ba652079a369f4eee0de9d9d:
> > 
> >   qnap-poweroff: Fix license string (2013-01-19 18:04:04 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.linaro.org/people/ljones/linux-3.0-ux500.git tb-power-2
> > 
> > for you to fetch changes up to 34c11a709e928090cf34ecd706f7d3170f4e5026:
> > 
> >   u8500-charger: Delay for USB enumeration (2013-01-23 14:39:22 +0000)
> 
> Did you pull this in the end?

I was buried under my homework, sorry. :-) The changes look good, thanks a
lot! Pulled now.

Anton
