Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbaD2Tm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:42:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52952 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaD2Tmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:42:54 -0400
Message-ID: <536000BA.4000101@wwwdotorg.org>
Date: Tue, 29 Apr 2014 13:42:50 -0600
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
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com> <1397719309-2022-2-git-send-email-computersforpeace@gmail.com> <535A8FC9.8040707@wwwdotorg.org> <20140429190603.GB9418@norris-Latitude-E6410>
In-Reply-To: <20140429190603.GB9418@norris-Latitude-E6410>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 01:06 PM, Brian Norris wrote:
> Hi Stephen,
> 
> On Fri, Apr 25, 2014 at 10:39:37AM -0600, Stephen Warren wrote:
>> On 04/17/2014 01:21 AM, Brian Norris wrote:
>>> These defconfigs contain the CONFIG_M25P80 symbol, which is now
>>> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
>>> relevant defconfigs.
>>>
>>> At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
...
>> I think this should be split it up so that each defconfig can go through
>> the tree that owns it to avoid conflicts. If you repost split up, I can
>> apply the tegra_defconfig change to the Tegra tree.
> 
> OK, I'll try to split it up. Is ARM unique in tracking defconfigs in
> separate trees? I assume MIPS, PowerPC, and Blackfin won't require the
> same splitting? I'd like to avoid 31 patches when <20 could suffice.

Sorry, I have no idea how the other arches handle defconfigs:-(

I guess you could also just see if arm-soc (arm@kernel.org) will take
this patch, and deal with any merge conflicts that arise when they merge
all the sub-arch defconfig changes. I CC'd them to find out if they
think that's a better idea.
