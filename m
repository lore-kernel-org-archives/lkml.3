Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaCECbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:31:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2746 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaCECbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:31:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Mar 2014 18:26:50 -0800
Message-ID: <53168C5B.6070003@nvidia.com>
Date: Wed, 5 Mar 2014 10:30:51 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com>
 <1393932664-13319-4-git-send-email-wni@nvidia.com>
 <53164E78.5010708@wwwdotorg.org> <20140304222357.GA6125@roeck-us.net>
In-Reply-To: <20140304222357.GA6125@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 06:23 AM, Guenter Roeck wrote:
> On Tue, Mar 04, 2014 at 03:06:48PM -0700, Stephen Warren wrote:
>> On 03/04/2014 04:31 AM, Wei Ni wrote:
>>> Add dt node to describe the thermal zone for the nct1008.
>>>
>>> Change-Id: I0256836e52d73ec282574e4fd91df52958936e35
>>
>> ???????
>>
> I think this is for one of those open-source sites out there
> which count open source contributions. Not Ohloh, but similar.
> You have to specify that Change-Id to have it associate your
> name with the patch.

It's so sorry, I'm working for chromiumos, this change-id is generated
by gerrit, I should remove it.

> 
> Guenter
> 
>>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>>
>>> +	thermal-zones {
>>> +		nct1008-local {
>>> +			polling-delay-passive = <2000>; /* milliseconds */
>>
>> Nothing can possible make use of this node, since there's no compatible
>> value or anything else like that to bind a driver to it.

We have special Tskin driver that estimator skin temperature based on
nct1008 local and remote sensors.

Thanks.
Wei.

>>

