Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaKZFYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:24:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48256 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaKZFYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:24:37 -0500
Message-ID: <547563E7.7080106@ti.com>
Date: Wed, 26 Nov 2014 10:53:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 6/7] ARM: mvebu: add PHY support to the dts for the
 USB controllers on Armada 375
References: <1415879269-29711-1-git-send-email-gregory.clement@free-electrons.com> <1415879269-29711-7-git-send-email-gregory.clement@free-electrons.com> <20141122020811.GO22670@titan.lakedaemon.net> <5470556B.6080608@free-electrons.com> <20141126035929.GJ22670@titan.lakedaemon.net> <54756164.3070206@ti.com> <20141126051701.GU22670@titan.lakedaemon.net>
In-Reply-To: <20141126051701.GU22670@titan.lakedaemon.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 26 November 2014 10:47 AM, Jason Cooper wrote:
> On Wed, Nov 26, 2014 at 10:43:08AM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Wednesday 26 November 2014 09:29 AM, Jason Cooper wrote:
>>> On Sat, Nov 22, 2014 at 10:20:43AM +0100, Gregory CLEMENT wrote:
>>>> Hi Jason,
>>>>
>>>> On 22/11/2014 03:08, Jason Cooper wrote:
>>>>> On Thu, Nov 13, 2014 at 12:47:48PM +0100, Gregory CLEMENT wrote:
>>>>>> Now that the USB cluster node has been added, use it as a PHY provider
>>>>>> for the USB controller linked to it: the first EHCI and the xHCI.
>>>>>>
>>>>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>
>> Looks like I'm not cc'ed in v4 of this patch series :-(
> 
> I've bounced emails maybe three times in my life.  Thought it might work
> here.  Did it?

Actually I'm CC'ed, just that search didn't find it. Sorry for the noise.

Thanks
Kishon
> 
> thx,
> 
> Jason.
> 
