Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaEAGIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:08:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38493 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaEAGIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:08:43 -0400
Date: Wed, 30 Apr 2014 23:08:38 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency for
 M25P80)
Message-ID: <20140501060838.GI2497@norris-Latitude-E6410>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
 <20140429190603.GB9418@norris-Latitude-E6410>
 <20140430114548.GQ28159@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430114548.GQ28159@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 07:45:48AM -0400, Jason Cooper wrote:
> On Tue, Apr 29, 2014 at 12:06:03PM -0700, Brian Norris wrote:
> > I'll also rebase on linux-next. I think there may be a few conflicts.
> 
> I can't speak for the other sub-archs, but I typically prefer that
> patches be based on an -rc tag, -rc1 if possible.

OK, this was already based on -rc1. I'll leave it as-is, and maintainers
can easily work out the conflicts.

Thanks,
Brian
