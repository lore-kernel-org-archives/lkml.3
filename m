Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161310Ab3FUMZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:25:55 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:62885 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161113Ab3FUMZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:25:53 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH v7] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH v7] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHObk/a50aBiA7m/Ems63A7bGu5oQ==
Date: Fri, 21 Jun 2013 12:25:48 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5F5DBB@DE02WEMBXB.internal.synopsys.com>
References: <1371799241-27771-1-git-send-email-abrodkin@synopsys.com>
	<1371810775.19215.30.camel@joe-AO722>
	<4881796E12491D4BB15146FE0209CE643F5F587E@DE02WEMBXB.internal.synopsys.com>
 <CAHp75Vf8A7YZGBtna7JAaacnJWq5+q_+m44eO13bChxKj6XZgQ@mail.gmail.com>
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

On 06/21/2013 04:15 PM, Andy Shevchenko wrote:
> On Fri, Jun 21, 2013 at 1:53 PM, Alexey Brodkin
> <Alexey.Brodkin@synopsys.com> wrote:
>
> []
>
>> But during compilation on x86 one needs to enable OF. Which will lead to
>> compilation errors in other things.
>
> JFYI, x86 has at least one platform with official OF dependency.
> Once I actually tried to build kernel for Intel MID with OF enabled
> (it required a hack in the arch Kconfig, of course), compiled fine.

Ok, good to know it.

Any other comments on patch itself?

-Alexey
