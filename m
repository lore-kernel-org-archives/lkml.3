Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab3CTSIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:08:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8786 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3CTSIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:08:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 11:08:44 -0700
Message-ID: <5149FA9E.6010702@nvidia.com>
Date: Wed, 20 Mar 2013 23:36:22 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] ARM: tegra: dalmore: add dt node for TPS65090's regulators
References: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com> <1363787070-14801-4-git-send-email-ldewangan@nvidia.com> <5149EA8F.6090806@nvidia.com>
In-Reply-To: <5149EA8F.6090806@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013 10:27 PM, Rhyland Klein wrote:
> On 3/20/2013 9:44 AM, Laxman Dewangan wrote:
> +			regulators {
> +				dcdc1 {
> +					regulator-name = "vdd-sys-5v0";
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> You should also add the tps65090_dcdc1_reg label to dcdc1. I believe you
> make use of it in patch 4 and this currently causes build breaks.
>

Actually patch 4 uses this label and I should add on patch 4, not on 
patch 3.

I removed from patch3 and when cherrypick the patch 4 from different 
branch to make the patches, I missed the change and hence patch 4 is not 
getting compiled.

I will fix the issue on next revision.

Sorry for messing up and thins for pointing this.




