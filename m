Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaGQD3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:29:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56842 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaGQD3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:29:48 -0400
Date: Wed, 16 Jul 2014 20:29:45 -0700 (PDT)
Message-Id: <20140716.202945.2231269352453909430.davem@davemloft.net>
To: michel@daenzer.net
Cc: romieu@fr.zoreil.com, hayeswang@realtek.com, nic_swsd@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
From: David Miller <davem@davemloft.net>
In-Reply-To: <53C71F1F.8040607@daenzer.net>
References: <20140715215412.GA19363@electric-eye.fr.zoreil.com>
	<20140716.152517.952351917803362794.davem@davemloft.net>
	<53C71F1F.8040607@daenzer.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 20:29:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <michel@daenzer.net>
Date: Thu, 17 Jul 2014 09:55:59 +0900

> On 17.07.2014 07:25, David Miller wrote:
>> From: Francois Romieu <romieu@fr.zoreil.com>
>> Date: Tue, 15 Jul 2014 23:54:12 +0200
>> 
>>> Hayes Wang <hayeswang@realtek.com> :
>>>>  Michel D?nzer [mailto:michel@daenzer.net] 
>>> [...]
>>>>> Without this, the ethernet port on my ASUS A88X Pro mainboard stops
>>>>> working sometimes, with messages like these in dmesg:
>>>>>
>>>>> AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 
>>>>> domain=0x001e address=0x0000000000003000 flags=0x0050]
>>>>
>>>> I search the information about your issue. It seems to be
>>>> relative to the IOMMU. I don't sure if your patch is the root
>>>> cause or a workaround.
>>>
>>> Btw, a few extra identifiers in rtl_init_rxcfg may improve consistency:
>>>
>>>            missing             |          included
>>> -------------------------------+-------------------------------
>>> RTL_GIGA_MAC_VER_36 (8168f)    | RTL_GIGA_MAC_VER_35 (8168f)
>>> RTL_GIGA_MAC_VER_38 (RTL8411)  | RTL_GIGA_MAC_VER_44 (RTL8411)
>>> RTL_GIGA_MAC_VER_39 (RTL8106e) | RTL_GIGA_MAC_VER_43 (RTL8106e)
>>> RTL_GIGA_MAC_VER_37 (RTL8402)  |
>> 
>> Michel please take Francois's feedback here into consideration and also
>> provide a more detailed commit message so other people reading the commit
>> can understand your reasoning for making this change, not just what the
>> result might be for making it.
> 
> I'm afraid I can't do that. I don't really understand any of this stuff,
> I just googled the IOMMU event message, found similar patches for other
> chipsets, and adapted them for my mainboard until the problem stopped.

And if so, that's exactly what I want you to say in the commit message.
