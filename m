Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3AVGGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:06:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50382 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AVGGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:06:52 -0500
Message-ID: <50FE2CA8.20100@ti.com>
Date: Tue, 22 Jan 2013 11:37:36 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>, <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com> <1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013 11:22 AM, Hiroshi Doyu wrote:
> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.
>
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
Looks fine. I will also update OMAP code with the new
interface. Thanks.

For the patch,
Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
