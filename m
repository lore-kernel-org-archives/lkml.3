Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaKFQxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:53:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbaKFQxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:53:46 -0500
Message-ID: <545BA77F.2080609@ti.com>
Date: Thu, 6 Nov 2014 10:53:19 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Tom Rini <trini@ti.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <beagleboard@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <gerald@granddesignsgroup.com>, <fcooper@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: Add am57xx-beagle-x15
References: <1415290702-11353-1-git-send-email-nm@ti.com> <20141106163207.GF16896@saruman> <545BA3E6.90105@ti.com> <545BA513.2090907@ti.com> <20141106164843.GY31454@atomide.com>
In-Reply-To: <20141106164843.GY31454@atomide.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 10:48 AM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [141106 08:44]:
>> On 11/06/2014 10:37 AM, Tom Rini wrote:
>>
>>>>> device_type = "memory"; +		reg = <0x80000000 0x40000000>; /* 1GB
>>>>> to start. Target 2GB */
>>>>
>>>> 1GiB ? Why would you put this here btw ? u-boot fills this one up.
>>>
>>> Yes, it should either be the full and correct value or 0x0 (like a
>>> number of PowerPC platforms do) so it's clear something else gives us
>>> the right value here.
>>
>> Honest mistake, my bad.. I thought I cleaned up the patch! Sigh!!! i
>> will repost with proper 2GB. it is better that way in case being used
>> with "other bootloaders" which are not exactly too good like u-boot.
> 
> Can you also describe why all the always-on regulators are needed?
yep - will do that similar to
https://patchwork.kernel.org/patch/5125431/ - same rationale unless
there is any specific voltage rail that you are explicitly interested
in that needs additional explanation. Is there additional rails of
interest?



-- 
Regards,
Nishanth Menon
