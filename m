Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3FLPgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:36:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40462 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3FLPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:36:15 -0400
Message-ID: <51B8956B.8020704@wwwdotorg.org>
Date: Wed, 12 Jun 2013 09:36:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>, mturquette@linaro.org
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V4 1/4] ARM: tegra30: clocks: Fix pciex clock registration
References: <1371021223-6709-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1371021223-6709-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 01:13 AM, Jay Agarwal wrote:
> Registering pciex as peripheral clock instead of fixed clock
> as tegra_perih_reset_assert(deassert) api of this clock api
> gives warning and ultimately does not succeed to assert(deassert)
> 
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> ---
> Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

In this case, it would make more sense to apply this to the clock tree,
since it's a standalone bug-fix.

Acked-by: Stephen Warren <swarren@nvidia.com>

