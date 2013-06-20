Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260Ab3FTLX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:23:27 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:48739 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007Ab3FTLX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:23:26 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Florian Fainelli <florian@openwrt.org>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>, Joe Perches <joe@perches.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v5] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH v5] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHObMTB0pUCWSTLfkKwzmR6uOQoOA==
Date: Thu, 20 Jun 2013 11:22:55 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5F344E@DE02WEMBXB.internal.synopsys.com>
References: <1371629537-8076-1-git-send-email-abrodkin@synopsys.com>
 <CAHp75Vc-Aza03ZLJj3CkLP2YhvdRi94bfutxKbV34hTc1_6k4g@mail.gmail.com>
 <4881796E12491D4BB15146FE0209CE643F5F2F56@DE02WEMBXB.internal.synopsys.com>
 <CAGVrzcYoz-pGG46otLjZDHs=xek-qpPEWxUtDQV1CcWCPs8WYg@mail.gmail.com>
 <4881796E12491D4BB15146FE0209CE643F5F30BF@DE02WEMBXB.internal.synopsys.com>
 <CAGVrzcZL3LYDeqCfBK-rLHuvWrAYfLRE1puJcqTjuEPyFKTo9w@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 02:37 PM, Florian Fainelli wrote:
> 2013/6/20 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
>> On 06/20/2013 01:57 PM, Florian Fainelli wrote:
>>> 2013/6/20 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
[]

> No, it would be c0fc2000, which is, so we are just fine. Drivers that
> support DT instantiation or platform_device/driver should in general
> use <pdev->name>-<pdev->id> which works fine in both cases.
Ok, I see now.

"pdev->name" indeed leads to "bus->id" = "c0fc2000.etherne".
Initially I thought about "pdev->dev.of_node->name" because I passed 
"pdev->dev.of_node" to "arc_mdio_probe".

Thanks for clarification.

-Alexey
