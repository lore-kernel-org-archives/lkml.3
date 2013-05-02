Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983Ab3EBUJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:09:03 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37228 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277Ab3EBUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:09:01 -0400
Message-ID: <5182C7D3.3040308@free-electrons.com>
Date: Thu, 02 May 2013 22:08:51 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130502185322.GA29333@obsidianresearch.com> <5182B902.7040908@gmail.com> <20130502193510.GA29522@obsidianresearch.com> <5182C322.3030304@gmail.com> <20130502200204.GA24965@lunn.ch>
In-Reply-To: <20130502200204.GA24965@lunn.ch>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 10:02 PM, Andrew Lunn wrote:
> On Thu, May 02, 2013 at 09:48:50PM +0200, Sebastian Hesselbarth wrote:
>> On 05/02/2013 09:35 PM, Jason Gunthorpe wrote:
>>> I have kirkwood HW but I haven't had time to make newer kernels run on
>>> it, otherwise I'd test it too :(
>>
>> I also have kirkwood HW but that will cut me from email as I use it as
>> relay server ;) Maybe I can turn it into a test bed for a while.
>>
>> There is also Orion5x and Discovery Innovation (mv78xx0) to be tested.
> 
> I can test kirkwood and Orion5x.

And I can test mv78xx0

Gregory
