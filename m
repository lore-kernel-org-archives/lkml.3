Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3AVQ5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:57:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56917 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3AVQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:57:43 -0500
Message-ID: <50FEC503.2080602@wwwdotorg.org>
Date: Tue, 22 Jan 2013 09:57:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com> <1358833924-24535-2-git-send-email-hdoyu@nvidia.com> <50FE2CA8.20100@ti.com>
In-Reply-To: <50FE2CA8.20100@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 11:07 PM, Santosh Shilimkar wrote:
> On Tuesday 22 January 2013 11:22 AM, Hiroshi Doyu wrote:
>> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.
>>
>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>> ---
> Looks fine. I will also update OMAP code with the new
> interface. Thanks.

OK, so patch 1/2 at least needs to get into a stable arm-soc branch
then. Unless there are violent objections, I'll forward patch 1/2 to
arm-soc and request it be added into a branch so that Tegra and OMAP can
both merge it into their branches as a dependency. I guess patch 2/2
could also be included; I don't think it has any complex dependencies
that'd prevent that, and would help to show how patch 1/2 gets used.

Hiroshi, is this series the only dependency you need for your Tegra114
series? So, I could merge your Tegra114 series once this series is applied?

> For the patch,
> Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>

Thanks.
