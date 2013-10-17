Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3JQEkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 00:40:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16025 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3JQEkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 00:40:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 21:39:59 -0700
Message-ID: <525F6A1B.70505@nvidia.com>
Date: Thu, 17 Oct 2013 12:39:55 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
References: <5253A17E.10503@nvidia.com> <20131008090910.GW21581@sirena.org.uk> <5253D489.7010900@nvidia.com> <20131012121412.GJ2443@sirena.org.uk> <525E17DE.6080301@nvidia.com> <20131016103942.GG2443@sirena.org.uk>
In-Reply-To: <20131016103942.GG2443@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 06:39 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Wed, Oct 16, 2013 at 12:36:46PM +0800, Wei Ni wrote:
>> On 10/12/2013 08:14 PM, Mark Brown wrote:
> 
>>> OK, I think the device tree board code just needs to set full
>>> constraints during machine initialisation.  We can't have multiple
> 
>> Hi, Mark, do you mean we can call regulator_has_full_constraints(), but
>> some platforms doesn't have board file now, they only have dts file, how
>> to call this functions?
> 
> There is still a board file for DT machines, it's just shared between
> all machines - it should be doing the call instead of the regulator
> framework trying to retrofit it.

So do you mean it should call the regulator_has_full_constraints() in
the .init_machine for all machines? If so, this will affect all boards,
for example, in arch/arm/mach-tegra, if we set full constraints in the
shared board file tegra.c, all tegra boards will be set, is it right?

Thanks.
Wei.

> 
> * Unknown Key
> * 0x7EA229BD
> 

