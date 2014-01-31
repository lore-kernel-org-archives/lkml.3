Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaAaCS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:18:58 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61562 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaAaCS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:18:56 -0500
Message-ID: <52EB080A.2020200@gmail.com>
Date: Fri, 31 Jan 2014 03:18:50 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/21] pinctrl: mvebu: restructure and remove hardcoded
 addresses from Dove pinctrl
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com> <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140130182925.GM10864@lunn.ch> <52EA9EFA.1030609@gmail.com> <20140130202500.GN10864@lunn.ch>
In-Reply-To: <20140130202500.GN10864@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 09:25 PM, Andrew Lunn wrote:
> On Thu, Jan 30, 2014 at 07:50:34PM +0100, Sebastian Hesselbarth wrote:
>> On 01/30/2014 07:29 PM, Andrew Lunn wrote:
>>> On Tue, Jan 28, 2014 at 01:39:12AM +0100, Sebastian Hesselbarth wrote:
>>>> This patch set is one required step for Dove to hop into mach-mvebu.
>>>> Until now, pinctrl-dove was hardcoding some registers that do not
>>>> directly belong to MPP core registers. This is not compatible with
>>>> what we want for mach-mvebu.
>>>
>>> I think there might be something wrong here....
>>
>> There _is_ something wrong. I'll have a look at it. For the record,
>> what SoC are you testing with? From the base address, I guess it is
>> Kirkwood?
>
> Yes, Kirkwood. Sorry for not saying.

This time I push a branch before sending out the patches. Also, I
think I'll postpone removal of hardcoded addresses until this is
sorted out. The patch set was growing way to quick and I have to
do this step-by-step for me and everybody else to actually understand ;)

So, at least the MVEBU guys should test the following branch on
their SoCs. Again, I have tested Dove and now confirmed that settings
are still correct. The others are compile-tested.

https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v3

@Thomas, Gregory: Do you think that the above branch will be
restructured enough allow support for orion5x and mv78xx0? I had a
quick look at mach-{orion5x,mv78xx0}/mpp.h and didn't see anything
weird.

Sebastian
