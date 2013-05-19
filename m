Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3ESPNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 11:13:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54420 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3ESPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 11:13:18 -0400
Date: Sun, 19 May 2013 17:13:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: Remove boilerplate debug_ll_io_init code
Message-ID: <20130519151314.GA7717@lukather>
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
 <201305160040.54399.arnd@arndb.de>
 <5194F944.2040803@free-electrons.com>
 <201305171531.16240.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305171531.16240.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, May 17, 2013 at 03:31:16PM +0200, Arnd Bergmann wrote:
> On Thursday 16 May 2013, Maxime Ripard wrote:
> 
> > 
> > How will we merge this? The first patch would be merged by Russel and
> > the 3 others by their respective maintainers?
> 
> I think since it's mostly platform code and all trivial, we can merge
> it into the next/cleanup branch in arm-soc directly.

Ok, then I can probably merge it into the branch with the irqchip_init
patches and send both these cleanups into the same branch in a few
weeks?

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
