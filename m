Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaDOJuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:50:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:24967 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaDOJuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,863,1389772800"; 
   d="scan'208";a="521051970"
Message-ID: <534D0370.50108@linux.intel.com>
Date: Tue, 15 Apr 2014 13:01:20 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>
CC: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org>
In-Reply-To: <534BFAAF.3070805@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 06:11 PM, Timur Tabi wrote:
> On 04/14/2014 02:52 AM, Mathias Nyman wrote:
>>>
>>
>> This was the conclusion we reached after some discussion with Linus W.
>> Initially this was just a GPIO driver, but Linus correctly spotted that
>> Baytrail has many pinctrl-like features (like pin muxing, etc) that we
>> might need to address in the future.
>>
>> threads where this was discussed:
>>
>> http://marc.info/?l=linux-kernel&m=136994203308585&w=2
>> http://marc.info/?l=linux-kernel&m=137113578604763&w=2
>
> So this is the interesting part:
>
>> We expect BIOS to set all pin configurations correctly.
>
> This device will only be used on an ACPI system, right?  And isn't ACPI
> supposed to hide all the pinctrl programming from the OS?  I thought
> that was the whole point behind ACPI and the reason why ARM64 isn't
> going to use device trees.
>

This was my starting point as well, and the driver was initially 
submitted as a GPIO driver. But Linus W. suggested pinctrl instead, and 
as he's the maintainer of both those subsystem I trust his judgment.


-Mathias
