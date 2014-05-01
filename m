Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaEAQsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:48:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58378 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaEAQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:48:52 -0400
Message-ID: <53627AF0.6060408@wwwdotorg.org>
Date: Thu, 01 May 2014 10:48:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        linux-mtd@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency
 for M25P80)
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com> <1397719309-2022-2-git-send-email-computersforpeace@gmail.com> <535A8FC9.8040707@wwwdotorg.org> <20140429190603.GB9418@norris-Latitude-E6410> <536000BA.4000101@wwwdotorg.org> <20140501060739.GH2497@norris-Latitude-E6410>
In-Reply-To: <20140501060739.GH2497@norris-Latitude-E6410>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 12:07 AM, Brian Norris wrote:
> On Tue, Apr 29, 2014 at 01:42:50PM -0600, Stephen Warren wrote:
>> I guess you could also just see if arm-soc (arm@kernel.org) will take
>> this patch, and deal with any merge conflicts that arise when they merge
>> all the sub-arch defconfig changes. I CC'd them to find out if they
>> think that's a better idea.
> 
> I'm preparing a split patch series and should send v2 shortly. A few of
> the unaccounted platforms + the multi-platform are lumped together for
> direct inclusion in arm-soc (?).
> 
> What is this arm@kernel.org you speak of? My Google-fu doesn't turn up a
> separate arm-soc email / mailing list, and it's not in MAINTAINERS.

It's the email address of the ARM SoC maintainers (Arnd, Olof, Kevin).
All the ARM sub-architecture maintainers send their pull requests there,
which all get aggregated and forwarded to Linus. They also take some
patches directly, for cross-sub-architecture stuff like
multi_v7_defconfig, or small amounts of bug-fixes after the main pull
requests are sent.
