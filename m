Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3BDRGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:06:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38130 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3BDRGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:06:19 -0500
Message-ID: <510FEA88.8040802@wwwdotorg.org>
Date: Mon, 04 Feb 2013 10:06:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Terje Bergstrom <tbergstrom@nvidia.com>, amerilainen@nvidia.com,
        airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 7/8] ARM: tegra: Add board data and 2D clocks
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-8-git-send-email-tbergstrom@nvidia.com> <20130204112622.GC595@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130204112622.GC595@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 04:26 AM, Thierry Reding wrote:
> On Tue, Jan 15, 2013 at 01:44:03PM +0200, Terje Bergstrom wrote:
>> Add a driver alias gr2d for Tegra 2D device, and assign a
>> duplicate of 2D clock to that driver alias.
>> 
>> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com> --- 
>> arch/arm/mach-tegra/board-dt-tegra20.c    |    1 + 
>> arch/arm/mach-tegra/board-dt-tegra30.c    |    1 + 
>> arch/arm/mach-tegra/tegra20_clocks_data.c |    2 +- 
>> arch/arm/mach-tegra/tegra30_clocks_data.c |    1 + 4 files
>> changed, 4 insertions(+), 1 deletion(-)
> 
> With Prashant's clock rework patches now merged this patch can be 
> dropped.

Assuming this series is applied for 3.10 and not earlier, yes. I'd
certainly recommend applying for 3.10 not 3.9; the dependencies to
apply this for 3.9 given the AUXDATA/... requirements would be too
painful.
