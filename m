Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3FPSvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 14:51:41 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37566 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3FPSvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 14:51:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>, Jay Agarwal <jagarwal@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51B8956B.8020704@wwwdotorg.org>
Cc: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        jtukkinen@nvidia.com, kthota@nvidia.com
References: <1371021223-6709-1-git-send-email-jagarwal@nvidia.com>
 <51B8956B.8020704@wwwdotorg.org>
Message-ID: <20130616185132.7541.680@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH V4 1/4] ARM: tegra30: clocks: Fix pciex clock registration
Date: Sun, 16 Jun 2013 11:51:33 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-06-12 08:36:11)
> On 06/12/2013 01:13 AM, Jay Agarwal wrote:
> > Registering pciex as peripheral clock instead of fixed clock
> > as tegra_perih_reset_assert(deassert) api of this clock api
> > gives warning and ultimately does not succeed to assert(deassert)
> > 
> > Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> > ---
> > Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.
> 
> In this case, it would make more sense to apply this to the clock tree,
> since it's a standalone bug-fix.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

Pulled into clk-fixes for -rc7.

Regards,
Mike
