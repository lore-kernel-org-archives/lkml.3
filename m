Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3CTBnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:43:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19714 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3CTBnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:43:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 18:42:55 -0700
Subject: Re: [PATCH v2] ARM: tegra114: add speedo-based process
 identification
From: Danny Huang <dahuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Joseph Lo <josephl@nvidia.com>, Prashant Gaikwad <pgaikwad@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5148A645.9020009@wwwdotorg.org>
References: <1363605454-24176-1-git-send-email-dahuang@nvidia.com>
	 <5148A645.9020009@wwwdotorg.org>
Date: Wed, 20 Mar 2013 09:42:51 +0800
Message-ID: <1363743771.3573.55.camel@dahuang-vm>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 01:54 +0800, Stephen Warren wrote:
> On 03/18/2013 05:17 AM, Danny Huang wrote:
> > Add speedo-based process identifictaion for Tegra114.
> 
> I have applied this to Tegra's for-3.10/soc branch, with one addition below:
> 
> > diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c
> 
> > +#include <linux/kernel.h>
> 
> Here, I also added:
> 
> #include <linux/bug.h>
> 
> That's not needed in the Tegra for-next branch (which is based on
> 3.9-rc1), but is needed when merged into linux-next, and hence will
> presumably be needed once this is submitted into 3.10.

Thanks. Does it mean that we have to include the bug.h for all newly
created file for 3.10?

