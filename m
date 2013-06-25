Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3FYERy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 00:17:54 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:48363 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3FYERw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 00:17:52 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>, Joe Perches <joe@perches.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Florian Fainelli <florian@openwrt.org>,
        David Laight <david.laight@aculab.com>
Subject: Re: [PATCH v8] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH v8] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHOcJ9RwYQFoPDyZE+7SVCl+a+Z7Q==
Date: Tue, 25 Jun 2013 04:17:48 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5FFB9C@DE02WEMBXB.internal.synopsys.com>
References: <1372053267-19359-1-git-send-email-abrodkin@synopsys.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 09:54 AM, Alexey Brodkin wrote:
> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
> ARCAngel4/ML50x.

Any comments on this patch?

If not please consider applying.

Regards,
Alexey
