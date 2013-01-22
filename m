Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3AVREw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:04:52 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:41405 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3AVREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:04:47 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <50FEC503.2080602@wwwdotorg.org>
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
	<1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
	<50FE2CA8.20100@ti.com>
	<50FEC503.2080602@wwwdotorg.org>
Date: Tue, 22 Jan 2013 09:04:46 -0800
Message-ID: <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 8:57 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/21/2013 11:07 PM, Santosh Shilimkar wrote:
>> On Tuesday 22 January 2013 11:22 AM, Hiroshi Doyu wrote:
>>> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.
>>>
>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>> ---
>> Looks fine. I will also update OMAP code with the new
>> interface. Thanks.
>
> OK, so patch 1/2 at least needs to get into a stable arm-soc branch
> then. Unless there are violent objections, I'll forward patch 1/2 to
> arm-soc and request it be added into a branch so that Tegra and OMAP can
> both merge it into their branches as a dependency. I guess patch 2/2
> could also be included; I don't think it has any complex dependencies
> that'd prevent that, and would help to show how patch 1/2 gets used.
>
> Hiroshi, is this series the only dependency you need for your Tegra114
> series? So, I could merge your Tegra114 series once this series is applied?

For something like this, it might make more sense for us to just apply
the patches for OMAP on top, i.e. we'll pull the short branch from
you, and then we can just apply patches (with maintainer acks) on top,
instead of doing a bunch of single-patch pulls.

Since Russell had comments on it earlier, I'd like him to give a nod
that he's happy with it too.


-Olof
