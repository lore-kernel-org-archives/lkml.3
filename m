Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaHUQfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:35:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37589 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHUQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:35:24 -0400
Message-ID: <53F61FDC.4000604@wwwdotorg.org>
Date: Thu, 21 Aug 2014 10:35:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        thierry.reding@gmail.com, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] ARM: tegra: Add thermal trip points for Jetson
 TK1
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com> <1407320706-17440-4-git-send-email-mperttunen@nvidia.com> <53F4FA80.9050103@wwwdotorg.org> <20140821160442.GB17621@developer>
In-Reply-To: <20140821160442.GB17621@developer>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 10:04 AM, Eduardo Valentin wrote:
> Stephen,
>
> On Wed, Aug 20, 2014 at 01:44:00PM -0600, Stephen Warren wrote:
>> On 08/06/2014 04:25 AM, Mikko Perttunen wrote:
>>> This adds critical trip points to the Jetson TK1 device tree.
>>> The device will do a controlled shutdown when either the CPU, GPU
>>> or MEM thermal zone reaches 101 degrees Celsius.
>>
>>> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>
>>> +	thermal-zones {
>>> +		cpu {
>>> +			trips {
>> ...
>>> +			};
>>> +		};
>>
>> thermal.txt states that a cooling-maps sub-node is mandatory. However,
>> it seems to be missing here. Is the DT binding documentation overly
>> strict, or do we need to add such a node here?
>
> I believe the binding documentation is correct. I believe this driver
> should still evolve a little bit to accomplish full thermal DT
> description and include the cooling devices mapping.
>
> All the best,

Should we hold off applying the Tegra DT until we can actually fill in 
the cooling aspects, or are you OK with an empty cooling node as Mikko 
suggested?
