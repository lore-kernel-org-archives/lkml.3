Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEWVZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:25:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57315 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039AbaEWVZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:25:16 -0400
Message-ID: <537FBCB1.5010207@free-electrons.com>
Date: Fri, 23 May 2014 23:25:05 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>, Kishon Vijay Abraham I <kishon@ti.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Mathias Nyman <mathias.nyman@intel.com>, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 2/5] Documentation: dt-bindings: document the Armada 375
 USB cluster binding
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com> <1400257376-13251-2-git-send-email-gregory.clement@free-electrons.com> <537F13B2.6070500@ti.com> <20140523132145.GA31314@lunn.ch> <20140523133608.GB31314@lunn.ch> <537F52B0.5030204@ti.com> <20140523135943.GC31314@lunn.ch>
In-Reply-To: <20140523135943.GC31314@lunn.ch>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2014 15:59, Andrew Lunn wrote:
> On Fri, May 23, 2014 at 07:22:48PM +0530, Kishon Vijay Abraham I wrote:
>> hI,
>>
>> On Friday 23 May 2014 07:06 PM, Andrew Lunn wrote:
>>>> Do you want one .txt file per driver, or can we combine binding
>>>> documentations into one file? There should already be a mvebu-phy.txt,
>>>> which contains the sata phy usable on some of the Armada SoC families.
>>>> This binding could be appended to it.
>>>
>>> Ah. Humm, well! It seems the patch adding the mvebu-phy.txt fell
>>> through a crack when adding the driver.
>>>
>>> Kishon could you take
>>> http://www.spinics.net/lists/devicetree/msg17018.html into your tree?
>>> It should of been taken the same time you took the actual driver,
>>> http://www.spinics.net/lists/devicetree/msg17011.html into your tree.
>>>
>>> I can resend that one missing patch if you want.
>>
>> yes please. But it's already too late to go in the next merge window.
> 
> Gregory, could you pick it up and append your 375 binding to it? We
> can avoid merge conflicts that way.

yes sure, I will do it

> 
> Thanks
> 	Andrew
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
