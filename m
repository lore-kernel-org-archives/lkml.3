Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaC1JZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:25:35 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:7589 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaC1JZd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:25:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzc89bhda00hdc73hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h268bh1889i1155h)
Message-ID: <53354057.6030004@freescale.com>
Date: Fri, 28 Mar 2014 17:26:47 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-mtd@lists.infradead.org>, Shawn Guo <shawn.guo@freescale.com>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
References: <1395399017-19005-1-git-send-email-LW@KARO-electronics.de> <20140324095902.GB11377@localhost> <20140326095156.3e5585b8@ipc1.ka-ro> <5332AEE7.2040402@freescale.com> <20140326125502.0e8d0657@ipc1.ka-ro> <20140327095956.GA29623@localhost> <20140327132109.06258526@ipc1.ka-ro> <5334D9F7.2030001@freescale.com> <20140328091646.1ce03f90@ipc1.ka-ro> <53353524.9020605@freescale.com> <20140328090023.GB17250@pengutronix.de>
In-Reply-To: <20140328090023.GB17250@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年03月28日 17:00, Sascha Hauer 写道:
> - disables swapping of BB marks in the FCB the ROM won't swap bytes.
We can not disable the swapping in the FCB in the imx28.
The DISBBM bit in the FCB does _NOT_ exit in the imx28's FCB.


thanks
Huang Shijie

