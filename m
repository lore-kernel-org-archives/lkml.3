Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaDWRn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:43:28 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34225 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaDWRn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:43:26 -0400
Message-ID: <5357FBBA.6070107@gmail.com>
Date: Wed, 23 Apr 2014 19:43:22 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: zmxu@marvell.com, jszhang@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] ARM: dts: berlin: enable SD card reader and eMMC
 for the BG2Q DMP
References: <1398155248-1659-1-git-send-email-antoine.tenart@free-electrons.com> <1398155248-1659-3-git-send-email-antoine.tenart@free-electrons.com> <5357F7BF.8000703@gmail.com> <20140423173631.GA10464@kwain>
In-Reply-To: <20140423173631.GA10464@kwain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 07:36 PM, Antoine Ténart wrote:
> On Wed, Apr 23, 2014 at 07:26:23PM +0200, Sebastian Hesselbarth wrote:
>> On 04/22/2014 10:27 AM, Antoine Ténart wrote:
>>> Enable the SD Card reader and the internal eMMC on the Berlin BG2Q DMP
>>> using two of the SDHCI nodes of the Berlin BG2Q.
>>>
>>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>>> ---
>>>  arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
>>> index 2da9c41e29d8..6ca8c9e52b08 100644
>>> --- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
>>> +++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
>>> @@ -26,3 +26,14 @@
>>>  &uart0 {
>>>  	status = "okay";
>>>  };
>>> +
>>> +&sdhci1 {
>>
>> Antoine,
>>
>> nit: please sort referenced nodes alphabetically.
>>
>> With your comments about mmc aliases, I can take both patches
>> in now (and fixup ordering) if you like.
> 
> You can take them.
> 
> I talked with Jisheng about this and the plan is to make a following up
> series for the aliases since it will require to modify the subsystem.

Applied both patches to berlin/dt, with &uart0, &sdhci1, &sdhci2 sorted
alphabetically now.

Sebastian

