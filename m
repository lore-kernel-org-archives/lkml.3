Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaGKJig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:38:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48892 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaGKJid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:38:33 -0400
Message-ID: <53BFBB74.80104@ti.com>
Date: Fri, 11 Jul 2014 13:24:52 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <devicetree@vger.kernel.org>
CC: <f.fainelli@gmail.com>, <santosh.shilimkar@ti.com>,
        <netdev@vger.kernel.org>, <prabhakar.csengg@gmail.com>,
        <nsekhar@ti.com>, <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 1/2] net: davinci_mdio: reuse for keystone2 arch
References: <1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>	<20140709.165232.539576872991411664.davem@davemloft.net>	<53BE8DF7.9090303@ti.com> <20140710.123900.1696373067218564684.davem@davemloft.net>
In-Reply-To: <20140710.123900.1696373067218564684.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 10:39 PM, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Thu, 10 Jul 2014 15:58:31 +0300
>
>> Hi David,
>>
>> On 07/10/2014 02:52 AM, David Miller wrote:
>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Date: Wed, 9 Jul 2014 16:10:50 +0300
>>>
>>>>    Required properties:
>>>> -- compatible		: Should be "ti,davinci_mdio"
>>>> +- compatible		: Should be "ti,davinci_mdio" or "ti,keystone-mdio"
>>>
>>> Why the inconsistency in naming schemes?  I don't see any reason
>>> to be different wrt. "_" vs. "-" in the name string.
>>>
>>
>> Hm. Looks like the common way is to use "-", but I can rename it if you insist.
>
> I'm just saying, is there a strong reason to be inconsistent?
>

I've followed the same format as for all latest compatibility strings in 
Kernel. Also I've checked ePAPR and dash is used for all examples there.

"ti,davinci_mdio" was added 2 years ago, so possibly no strict 
convention or review were done then. Now, I can't change 
"ti,davinci_mdio" -> "ti,davinci-mdio" to be consistent with Kernel due 
to compatibility issues.

May be DT Gurus can say more?


Regards,
-grygorii
