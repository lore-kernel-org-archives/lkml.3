Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab3JPEgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 00:36:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4216 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3JPEgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 00:36:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 21:36:45 -0700
Message-ID: <525E17DE.6080301@nvidia.com>
Date: Wed, 16 Oct 2013 12:36:46 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
References: <5253A17E.10503@nvidia.com> <20131008090910.GW21581@sirena.org.uk> <5253D489.7010900@nvidia.com> <20131012121412.GJ2443@sirena.org.uk>
In-Reply-To: <20131012121412.GJ2443@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 08:14 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Oct 08, 2013 at 05:46:49PM +0800, Wei Ni wrote:
> 
>> In the regulator_dev_lookup(), it will try to read the "xx-supply" to
>> get the regnode, but I didn't set the vcc-supply in dts file for lm90,
>> so the of_get_regulator() will return NULL, then the
>> regulator_dev_lookup() will set the ret to -ENODEV, and return the rdev
>> as NULL.
> 
> OK, I think the device tree board code just needs to set full
> constraints during machine initialisation.  We can't have multiple

Hi, Mark, do you mean we can call regulator_has_full_constraints(), but
some platforms doesn't have board file now, they only have dts file, how
to call this functions?

Wei.

> initcalls in the regulator code and doing it there is really a bit of a
> workaround anyway.
> 
> * Unknown Key
> * 0x7EA229BD
> 

