Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab3CNSMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:12:53 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47274 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3CNSMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:12:51 -0400
Message-ID: <5142124E.7050909@openwrt.org>
Date: Thu, 14 Mar 2013 19:09:18 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: davem@davemloft.net,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 0/5] mv643xx_eth: use mvmdio MDIO bus driver
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <20130314172544.GT12700@titan.lakedaemon.net>
In-Reply-To: <20130314172544.GT12700@titan.lakedaemon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Le 03/14/13 18:25, Jason Cooper a écrit :
> Florian,
>
> Any word on version 2 of this series?  I'd like to base the conversion
> of kirkwood to DT based ethernet init on it.

Just sent them out for review, thanks for reminder, they were sitting in 
my tree for a couple days already.
--
Florian
