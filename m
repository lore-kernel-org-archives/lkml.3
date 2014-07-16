Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaGPWZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:25:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55451 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaGPWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:25:18 -0400
Date: Wed, 16 Jul 2014 15:25:17 -0700 (PDT)
Message-Id: <20140716.152517.952351917803362794.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, michel@daenzer.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140715215412.GA19363@electric-eye.fr.zoreil.com>
References: <1405406500-1208-1-git-send-email-michel@daenzer.net>
	<0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>
	<20140715215412.GA19363@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 15:25:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Tue, 15 Jul 2014 23:54:12 +0200

> Hayes Wang <hayeswang@realtek.com> :
>>  Michel D?nzer [mailto:michel@daenzer.net] 
> [...]
>> > Without this, the ethernet port on my ASUS A88X Pro mainboard stops
>> > working sometimes, with messages like these in dmesg:
>> > 
>> > AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 
>> > domain=0x001e address=0x0000000000003000 flags=0x0050]
>> 
>> I search the information about your issue. It seems to be
>> relative to the IOMMU. I don't sure if your patch is the root
>> cause or a workaround.
> 
> Btw, a few extra identifiers in rtl_init_rxcfg may improve consistency:
> 
>            missing             |          included
> -------------------------------+-------------------------------
> RTL_GIGA_MAC_VER_36 (8168f)    | RTL_GIGA_MAC_VER_35 (8168f)
> RTL_GIGA_MAC_VER_38 (RTL8411)  | RTL_GIGA_MAC_VER_44 (RTL8411)
> RTL_GIGA_MAC_VER_39 (RTL8106e) | RTL_GIGA_MAC_VER_43 (RTL8106e)
> RTL_GIGA_MAC_VER_37 (RTL8402)  |

Michel please take Francois's feedback here into consideration and also
provide a more detailed commit message so other people reading the commit
can understand your reasoning for making this change, not just what the
result might be for making it.
