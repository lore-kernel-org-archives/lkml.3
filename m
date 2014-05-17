Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaEQEWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:22:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44242 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbaEQEWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:22:22 -0400
Date: Sat, 17 May 2014 06:22:16 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        arm@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris.brezillon@free-electrons.com, linus.walleij@linaro.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.16 #1
Message-ID: <20140517042216.GI29318@piout.net>
References: <1399484042-27432-1-git-send-email-nicolas.ferre@atmel.com>
 <536A6FD7.40402@atmel.com>
 <20140516232635.GB6423@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516232635.GB6423@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/2014 at 16:26:35 -0700, Olof Johansson wrote :
> On Wed, May 07, 2014 at 07:39:35PM +0200, Nicolas Ferre wrote:
> > There is a little conflict with at91-3.16-dt that you already pulled in
> > arm-soc: here is the branch that resolves it:
> > 
> > https://github.com/at91linux/linux-at91/commits/at91-3.16-resolved
> 
> That resolution looks odd. Why is one clock under clocks { } and two of them
> are at the top level? Shouldn't they all be under the clocks subnode?
> 
> I've merged in now with your resolution, but I think this needs revisiting.
> 

Actually, all the clocks should end up at the root, please refer to:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/240219.html

I feel that was one of the topics we should have discussed at ELC but we
ended up talking about DT ABI stability instead...

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
