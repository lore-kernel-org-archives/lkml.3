Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110Ab3FUMPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:15:53 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35768 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701Ab3FUMPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5F587E@DE02WEMBXB.internal.synopsys.com>
References: <1371799241-27771-1-git-send-email-abrodkin@synopsys.com>
	<1371810775.19215.30.camel@joe-AO722>
	<4881796E12491D4BB15146FE0209CE643F5F587E@DE02WEMBXB.internal.synopsys.com>
Date: Fri, 21 Jun 2013 15:15:50 +0300
Message-ID: <CAHp75Vf8A7YZGBtna7JAaacnJWq5+q_+m44eO13bChxKj6XZgQ@mail.gmail.com>
Subject: Re: [PATCH v7] ethernet/arc/arc_emac - Add new driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 1:53 PM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:

[]

> But during compilation on x86 one needs to enable OF. Which will lead to
> compilation errors in other things.

JFYI, x86 has at least one platform with official OF dependency.
Once I actually tried to build kernel for Intel MID with OF enabled
(it required a hack in the arch Kconfig, of course), compiled fine.

--
With Best Regards,
Andy Shevchenko
