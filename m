Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3BEErO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:47:14 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3628 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3BEErM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:47:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Feb 2013 20:44:11 -0800
Message-ID: <51108EC4.2090306@nvidia.com>
Date: Mon, 4 Feb 2013 20:47:00 -0800
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 7/8] ARM: tegra: Add board data and 2D clocks
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-8-git-send-email-tbergstrom@nvidia.com> <20130204112622.GC595@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130204112622.GC595@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.02.2013 03:26, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jan 15, 2013 at 01:44:03PM +0200, Terje Bergstrom wrote:
>> Add a driver alias gr2d for Tegra 2D device, and assign a duplicate
>> of 2D clock to that driver alias.
>>
>> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
>> ---
>>  arch/arm/mach-tegra/board-dt-tegra20.c    |    1 +
>>  arch/arm/mach-tegra/board-dt-tegra30.c    |    1 +
>>  arch/arm/mach-tegra/tegra20_clocks_data.c |    2 +-
>>  arch/arm/mach-tegra/tegra30_clocks_data.c |    1 +
>>  4 files changed, 4 insertions(+), 1 deletion(-)
> 
> With Prashant's clock rework patches now merged this patch can be
> dropped.

Yes, and I'll also need to start calling 2D clock with name NULL in gr2d.c.

Terje
