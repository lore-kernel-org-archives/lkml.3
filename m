Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3C0CwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:52:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37255 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3C0CwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:52:05 -0400
Message-ID: <51525ED2.80109@wwwdotorg.org>
Date: Tue, 26 Mar 2013 20:52:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH] hw_random: Add Broadcom BCM2835 RNG Driver
References: <1363956930-5717-1-git-send-email-lkundrak@v3.sk>  <514D1719.501@wwwdotorg.org> <1364135825.2906.14.camel@hobbes.kokotovo>
In-Reply-To: <1364135825.2906.14.camel@hobbes.kokotovo>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 08:37 AM, Lubomir Rintel wrote:
> On Fri, 2013-03-22 at 20:44 -0600, Stephen Warren wrote:
> 
> Thank you for your response!
> 
>> On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
>>> Signed-off-by: Lubomir Rintel <lkundrak at v3.sk>
>>
>> A commit description would be useful.
>>
>>>  arch/arm/boot/dts/bcm2835.dtsi       |    5 +
>>>  arch/arm/configs/bcm2835_defconfig   |    3 +-
>>>  drivers/char/hw_random/Kconfig       |   12 +++
>>>  drivers/char/hw_random/Makefile      |    1 +
>>>  drivers/char/hw_random/bcm2835-rng.c |  137 ++++++++++++++++++++++++++++++++++
>>
>> This should be split into 3 separate patches: (1) The driver itself, (2)
>> the change to bcm2835.dtsi, and (3) the change to bcm2835_defconfig.
>>
>> Since you're adding a new device to device tree for the first time, you
>> should write a binding document for it; most likely
>> Documentation/devicetree/bindings/rng/brcm,bcm2835.txt (or perhaps
>> /random/ rather than /rng/?)
> 
> Okay. I'm tempted to stick to "rng" instead of "random" as it seems more 
> consistent to me, but I don't have a strong reason to back it with. What would 
> be a good reason for using "random"?

I figured that "random" might be more meaningful/understandable for some
people. It's not a big deal either way though.

