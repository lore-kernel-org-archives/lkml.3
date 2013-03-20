Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3CTOlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:41:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3357 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab3CTOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:41:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 07:34:21 -0700
Message-ID: <5149CA11.2070301@nvidia.com>
Date: Wed, 20 Mar 2013 20:09:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: palmas: initialise client->of_node for dummy created
 client
References: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com> <514887D8.2020606@wwwdotorg.org> <20130319165228.GC22168@opensource.wolfsonmicro.com> <51489C0A.309@wwwdotorg.org> <20130319172648.GD22168@opensource.wolfsonmicro.com>
In-Reply-To: <20130319172648.GD22168@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 March 2013 10:56 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Mar 19, 2013 at 11:10:34AM -0600, Stephen Warren wrote:
>> On 03/19/2013 10:52 AM, Mark Brown wrote:
>>> This does then make it more complicated for all users of I2C as
>>> they need to become aware of such devices.  Not sure that's a
>>> win...
>> Presumably the existing APIs would work identically, and additional
>> APIs would be added for the complex case?
> Right, but we'd have to add the additional APIs to things like regmap
> and ASoC which seems like a kerfuffle.
>

Yes, to add the multiple address list in i2c_client, then adding address 
index in i2c apis, adding address index in regmap inits etc. can require 
lots of RFE patches in different subsystem. We can keep discussing this 
and once conclude, we can go for implementation.

But for now, can I assume that this patch is fine for resolving my 
interrupt issue?

Thanks,
Laxman

