Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3EPU6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:58:24 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56882 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3EPU6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:58:21 -0400
Message-ID: <5195486F.1040603@cogentembedded.com>
Date: Fri, 17 May 2013 00:58:23 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH] <linux/of_platform.h>: fix compilation warnings with
 DT disabled
References: <201302190258.25726.sergei.shtylyov@cogentembedded.com> <20130301070925.GA24369@verge.net.au> <5130B12F.20409@gmail.com> <5130B1A7.9060001@gmail.com> <5130B34F.2090700@cogentembedded.com> <5130B506.5020908@gmail.com>
In-Reply-To: <5130B506.5020908@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/01/2013 05:02 PM, Rob Herring wrote:

>>>>>> Fix the following compilation warnings (in Simon Horman's
>>>>>> renesas.git repo):
>>>>>> In file included from arch/arm/mach-shmobile/setup-r8a7779.c:24:0:
>>>>>> include/linux/of_platform.h:107:13: warning: ‘struct of_device_id’
>>>>>> declared
>>>>>> inside parameter list [enabled by default]
>>>>>> include/linux/of_platform.h:107:13: warning: its scope is only this
>>>>>> definition
>>>>>> or declaration, which is probably not what you want [enabled by
>>>>>> default]
>>>>>> include/linux/of_platform.h:107:13: warning: ‘struct device_node’
>>>>>> declared
>>>>>> inside parameter list [enabled by default]
>>>>>> <linux/of_platform.h> only #include's headers with definitions of
>>>>>> the above
>>>>>> mentioned structures if CONFIG_OF_DEVICE=y but uses them even if
>>>>>> not. One
>>>>>> solution is to move some #include's out of #ifdef CONFIG_OF_DEVICE
>>>>>> and use
>>>>>> incomplete declarations for the rest of the structures where the
>>>>>> #ifdef move
>>>>>> doesn't help...
>>>>>> Reported-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>>>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>>> Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
>>>>> Grant, could you consider taking this patch?
>>>> Yes, I can, but I don't seem to have the original patch. Can you send it
>>>> again.
>>> Nevermind. Found it. I'll apply it.
>>     Will you drop 'struct device_node' declaration then or should I
>> resend? In fact, I think I should better resend it with the changelog
>> somewhat edited.
> No, I plan to leave it as is and not rely on device.h by chance
> declaring device_node.

     I hoped to see this fix in 3.10-rc1. Is there any hope to see it in 
3.10-rc's?
The code it fixes the warnings in is already in Linus tree.

>
>>> Rob

WBR, Sergei

