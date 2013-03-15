Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3COMyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:54:38 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48081 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3COMyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:54:36 -0400
Message-ID: <51431935.6060407@openwrt.org>
Date: Fri, 15 Mar 2013 13:51:01 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        jason@lakedaemon.net, andrew@lunn.ch, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, paulus@samba.org, buytenh@wantstofly.org,
        thomas.petazzoni@free-electrons.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] mv643xx_eth: use mvmdio MDIO bus driver
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1363284515-9865-1-git-send-email-florian@openwrt.org> <20130315.085321.1047694772636447477.davem@davemloft.net>
In-Reply-To: <20130315.085321.1047694772636447477.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/15/13 13:53, David Miller a écrit :
> From: Florian Fainelli <florian@openwrt.org>
> Date: Thu, 14 Mar 2013 19:08:31 +0100
>
>> This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
>> instead of rolling its own implementation. As a result, all users of this
>> mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
>> The mvmdio driver is also updated to support an interrupt line which reports
>> SMI error/completion, and to allow traditionnal platform device registration
>> instead of just device tree.
>>
>> David, I think it makes sense for you to merge all of this, since we do
>> not want the architecture files to be desynchronized from the mv643xx_eth to
>> avoid runtime breakage. The potential for merge conflicts should be very small.
>
> All applied to net-next, thanks.
>

Oh woah that was fast, maybe too fast, I will submit a follow-up patch 
for patch 4 to address the issues I mentionned earlier.
--
Florian
