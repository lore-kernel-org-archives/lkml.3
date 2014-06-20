Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966126AbaFTJtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:49:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7724 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbaFTJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:49:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Jun 2014 02:43:31 -0700
Message-ID: <53A4039B.7000504@nvidia.com>
Date: Fri, 20 Jun 2014 18:49:15 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>, Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com> <53A308C8.2070004@wwwdotorg.org> <20140619175643.GR5099@sirena.org.uk> <53A3C613.8030207@nvidia.com> <53A3D85E.7030704@nvidia.com> <20140620094119.GT5099@sirena.org.uk>
In-Reply-To: <20140620094119.GT5099@sirena.org.uk>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 06:41 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jun 20, 2014 at 03:44:46PM +0900, Alexandre Courbot wrote:
>
>> dbabd624d
>> regulator: palmas: Reemove open coded functions with helper functions
>
>> Keerthy, Nishanth, could it be that there is still something wrong with the
>> REGULATOR_LINEAR_RANGE() definitions?
>
>> This seems to be the cause for our trouble, but the other questions might
>> still stand, in case there is interest in discussing them.
>
> There was a bug fix to the Palmas driver which just went to Linus the
> other day, are you sure this isn't fixed in mainline (or -next, it's
> been in -next for a week or something)?

If you are talking about

6b7f2d82d5
regulator: palmas: Fix SMPS list for 0V

then it is in my tree. There is actually no difference on 
palmas-regulator.c between my tree and the current -next (or Linus' tree 
for that instance).

So it seems to be something else we are dealing with here.
