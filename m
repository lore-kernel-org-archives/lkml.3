Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaCEC6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:58:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56608 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaCEC6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:58:33 -0500
Message-ID: <531692D2.6040204@wwwdotorg.org>
Date: Tue, 04 Mar 2014 19:58:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, Guenter Roeck <linux@roeck-us.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com> <1393932664-13319-4-git-send-email-wni@nvidia.com> <53164E78.5010708@wwwdotorg.org> <20140304222357.GA6125@roeck-us.net> <53168C5B.6070003@nvidia.com>
In-Reply-To: <53168C5B.6070003@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 07:30 PM, Wei Ni wrote:
> On 03/05/2014 06:23 AM, Guenter Roeck wrote:
>> On Tue, Mar 04, 2014 at 03:06:48PM -0700, Stephen Warren wrote:
>>> On 03/04/2014 04:31 AM, Wei Ni wrote:
>>>> Add dt node to describe the thermal zone for the nct1008.
>>>>
>>>> Change-Id: I0256836e52d73ec282574e4fd91df52958936e35
>>>
>>> ???????
>>>
>> I think this is for one of those open-source sites out there
>> which count open source contributions. Not Ohloh, but similar.
>> You have to specify that Change-Id to have it associate your
>> name with the patch.
> 
> It's so sorry, I'm working for chromiumos, this change-id is generated
> by gerrit, I should remove it.
> 
>>
>> Guenter
>>
>>>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>>>
>>>> +	thermal-zones {
>>>> +		nct1008-local {
>>>> +			polling-delay-passive = <2000>; /* milliseconds */
>>>
>>> Nothing can possible make use of this node, since there's no compatible
>>> value or anything else like that to bind a driver to it.
> 
> We have special Tskin driver that estimator skin temperature based on
> nct1008 local and remote sensors.

Where? Anything that gets added to the upstream kernel DT files must be
supported by a driver and binding in the upstream kernel.

