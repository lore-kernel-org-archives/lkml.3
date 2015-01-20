Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbbATTYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:24:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbATTX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:23:58 -0500
Message-ID: <54BEAB48.6090701@ti.com>
Date: Tue, 20 Jan 2015 14:23:52 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Wingman Kwok <w-kwok2@ti.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v8 2/4] net: netcp: Add Keystone NetCP core ethernet
 driver
References: <1421367172-19793-1-git-send-email-m-karicheri2@ti.com>   <1421367172-19793-2-git-send-email-m-karicheri2@ti.com>  <1421741935.9655.73.camel@x220> <54BE8BEA.3000100@ti.com> <1421774797.29393.4.camel@x220>
In-Reply-To: <1421774797.29393.4.camel@x220>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 12:26 PM, Paul Bolle wrote:
> On Tue, 2015-01-20 at 12:10 -0500, Murali Karicheri wrote:
>> On 01/20/2015 03:18 AM, Paul Bolle wrote:
>>> On Thu, 2015-01-15 at 19:12 -0500, Murali Karicheri wrote:
>>>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>>>> index 605dd90..e11bcfa 100644
>>>> --- a/drivers/net/ethernet/ti/Kconfig
>>>> +++ b/drivers/net/ethernet/ti/Kconfig
>>>> @@ -73,12 +73,23 @@ config TI_CPSW
>>>>    config TI_CPTS
>>>>    	boolean "TI Common Platform Time Sync (CPTS) Support"
>>>>    	depends on TI_CPSW
>>>> +	depends on TI_CPSW || TI_KEYSTONE_NET
>>>
>>> You probably meant to add
>>>       || TI_KEYSTONE_NETCP
>>>
>>> here. Ie, add CP. But as this slipped through testing it _might_ not be
>>> needed at all.
>>
>> Currently CPTS driver is not used for NetCP. So I want to remove the
>> above Kconfig dependency from Kconfig and cpts.o from the Makefile. Do
>> you expect me to send an incremental patch for this to the netdev list?
>
> That's Dave's call. I think that Dave works with incremental patches
> exclusively once things have hit (one of the trees that feed into)
> linux-next.
>
>> or can pick the attached patch that addresses this issue. Let me know.
>
> I'm just the reporter. Please send it through the regular channels. That
> would certainly include netdev.
>
Sure! I just posted the patch to the netdev list.

Thanks for letting me know.

Murali
>
> Paul Bolle
>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
