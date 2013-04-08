Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936095Ab3DHM6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:58:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18361 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936072Ab3DHM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:58:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 08 Apr 2013 05:58:32 -0700
Message-ID: <5162BE28.1080005@nvidia.com>
Date: Mon, 8 Apr 2013 18:25:04 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: palmas: initialise client->of_node for dummy created
 client
References: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com> <514887D8.2020606@wwwdotorg.org> <20130319165228.GC22168@opensource.wolfsonmicro.com> <51489C0A.309@wwwdotorg.org> <20130319172648.GD22168@opensource.wolfsonmicro.com> <5149CA11.2070301@nvidia.com>
In-Reply-To: <5149CA11.2070301@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013 08:09 PM, Laxman Dewangan wrote:
> On Tuesday 19 March 2013 10:56 PM, Mark Brown wrote:
>> * PGP Signed by an unknown key
>>
>> On Tue, Mar 19, 2013 at 11:10:34AM -0600, Stephen Warren wrote:
>>> On 03/19/2013 10:52 AM, Mark Brown wrote:
>>>> This does then make it more complicated for all users of I2C as
>>>> they need to become aware of such devices.  Not sure that's a
>>>> win...
>>> Presumably the existing APIs would work identically, and additional
>>> APIs would be added for the complex case?
>> Right, but we'd have to add the additional APIs to things like regmap
>> and ASoC which seems like a kerfuffle.
>>
> Yes, to add the multiple address list in i2c_client, then adding address
> index in i2c apis, adding address index in regmap inits etc. can require
> lots of RFE patches in different subsystem. We can keep discussing this
> and once conclude, we can go for implementation.
>
> But for now, can I assume that this patch is fine for resolving my
> interrupt issue?
>
> Thanks,
> Laxman
>

I did not heard any objection on this patch so requesting Samuel to 
considering this patch as of now?


