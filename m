Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3JQKkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:40:04 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10510 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3JQKkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:40:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 03:35:33 -0700
Message-ID: <525FBE7C.9080402@nvidia.com>
Date: Thu, 17 Oct 2013 18:39:56 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
References: <5253A17E.10503@nvidia.com> <20131008090910.GW21581@sirena.org.uk> <5253D489.7010900@nvidia.com> <20131012121412.GJ2443@sirena.org.uk> <525E17DE.6080301@nvidia.com> <20131016103942.GG2443@sirena.org.uk> <525F6A1B.70505@nvidia.com> <20131017093701.GH2443@sirena.org.uk>
In-Reply-To: <20131017093701.GH2443@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 05:37 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Oct 17, 2013 at 12:39:55PM +0800, Wei Ni wrote:
> 
>> So do you mean it should call the regulator_has_full_constraints() in
>> the .init_machine for all machines? If so, this will affect all boards,
>> for example, in arch/arm/mach-tegra, if we set full constraints in the
>> shared board file tegra.c, all tegra boards will be set, is it right?
> 
> Yes, but this is currently the case anyway for every system using DT -
> all we'd be doing is moving this call earlier in init.

Ok, I will send out patches for Tegra series.

> 
> * Unknown Key
> * 0x7EA229BD
> 

