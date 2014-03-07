Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaCGQWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:22:39 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44768 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaCGQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:22:37 -0500
Message-ID: <531A0065.3060001@cogentembedded.com>
Date: Fri, 07 Mar 2014 20:22:45 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 2/5] ARM: lager: add vin1 node
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk> <1394197299-17528-3-git-send-email-ben.dooks@codethink.co.uk> <5319F8D1.5050608@cogentembedded.com> <5319EE73.7010305@codethink.co.uk>
In-Reply-To: <5319EE73.7010305@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 07:06 PM, Ben Dooks wrote:

>>> Add device-tree for vin1 (composite video in) on the
>>> lager board.

>>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

>>     This patch should have been preceded by the VIN driver patch and
>> bindings description, don't you think?

>>> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts
>>> b/arch/arm/boot/dts/r8a7790-lager.dts
>>> index a087421..7528cfc 100644
>>> --- a/arch/arm/boot/dts/r8a7790-lager.dts
>>> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
>> [...]
>>> @@ -239,8 +244,41 @@
>>>       status = "ok";
>>>       pinctrl-0 = <&i2c2_pins>;
>>>       pinctrl-names = "default";
>>> +
>>> +    adv7180: adv7180@0x20 {

>>     ePAPR standard [1] tells us that:

>> "The name of a node should be somewhat generic, reflecting the function
>> of the device and not its precise programming model."

>>     So, I would suggest something like "video-decoder" instead. And
>> remove "0x" from the address part of the node name please.

> Personally I'm not fussed about names in the tree.

    I quoted the standard everybody should follow.

> I will look at changing it to something like vin1_decoder

    Please give it a generic name instead, without indexes and underscores.

WBR, Sergei

