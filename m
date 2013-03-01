Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3CANs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:48:28 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39695 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3CANs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:48:27 -0500
Message-ID: <5130B1A7.9060001@gmail.com>
Date: Fri, 01 Mar 2013 07:48:23 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-sh@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH] <linux/of_platform.h>: fix compilation warnings with
 DT disabled
References: <201302190258.25726.sergei.shtylyov@cogentembedded.com> <20130301070925.GA24369@verge.net.au> <5130B12F.20409@gmail.com>
In-Reply-To: <5130B12F.20409@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 07:46 AM, Rob Herring wrote:
> On 03/01/2013 01:09 AM, Simon Horman wrote:
>> On Tue, Feb 19, 2013 at 02:58:25AM +0300, Sergei Shtylyov wrote:
>>> Fix the following compilation warnings (in Simon Horman's renesas.git repo):
>>>
>>> In file included from arch/arm/mach-shmobile/setup-r8a7779.c:24:0:
>>> include/linux/of_platform.h:107:13: warning: ‘struct of_device_id’ declared
>>> inside parameter list [enabled by default]
>>> include/linux/of_platform.h:107:13: warning: its scope is only this definition
>>> or declaration, which is probably not what you want [enabled by default]
>>> include/linux/of_platform.h:107:13: warning: ‘struct device_node’ declared
>>> inside parameter list [enabled by default]
>>>
>>> <linux/of_platform.h> only #include's headers with definitions of the above
>>> mentioned structures if CONFIG_OF_DEVICE=y but uses them even if not. One
>>> solution is to move some #include's out of #ifdef CONFIG_OF_DEVICE and use
>>> incomplete declarations for the rest of the structures where the #ifdef move
>>> doesn't help...
>>>
>>> Reported-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
>>
>> Grant, could you consider taking this patch?
> 
> Yes, I can, but I don't seem to have the original patch. Can you send it
> again.

Nevermind. Found it. I'll apply it.

Rob

