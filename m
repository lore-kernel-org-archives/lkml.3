Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaEUNxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:53:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbaEUNx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:53:29 -0400
Message-ID: <537CAFD2.3080807@free-electrons.com>
Date: Wed, 21 May 2014 15:53:22 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Jason Cooper <jason@lakedaemon.net>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 10/17] ARM: mvebu: add USB3 support for Armada 38x
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>	 <1400149062-32661-11-git-send-email-gregory.clement@free-electrons.com>	 <20140516190729.GN27822@titan.lakedaemon.net> <1400497768.2007.10.camel@x220>
In-Reply-To: <1400497768.2007.10.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/2014 13:09, Paul Bolle wrote:
> On Fri, 2014-05-16 at 15:07 -0400, Jason Cooper wrote:
>> On Thu, May 15, 2014 at 12:17:35PM +0200, Gregory CLEMENT wrote:
>>> This patch adds the selection of the config symbol needed to build the
>>> USB3 support for Armada 38x into mvebu_v7_defconfig.
>>>
>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>>> ---
>>>  arch/arm/mach-mvebu/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>
>> Patches 10 and 11 applied to mvebu/soc
> 
> These two just hit linux-next (in next-20140519). They're pointless, as
> config USB_ARCH_HAS_XHCI was dropped in commit b797b76fb464 ("usb: host:
> remove USB_ARCH_HAS_?HCI").

Right! We didn't notice it.

Jason you can simply remove them from mvebu/soc when you will submit the pull request


Thanks,

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
