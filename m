Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaC1Jhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:37:35 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:58372
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbaC1Jhd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:37:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h268bh1889i1155h)
Message-ID: <53354329.2020909@freescale.com>
Date: Fri, 28 Mar 2014 17:38:49 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
References: <532BCFCC.4080205@freescale.com>	<1395399017-19005-1-git-send-email-LW@KARO-electronics.de>	<20140324095902.GB11377@localhost>	<20140326095156.3e5585b8@ipc1.ka-ro>	<5332AEE7.2040402@freescale.com>	<20140326125502.0e8d0657@ipc1.ka-ro>	<20140327095956.GA29623@localhost>	<20140327132109.06258526@ipc1.ka-ro>	<5334D9F7.2030001@freescale.com>	<20140328091646.1ce03f90@ipc1.ka-ro>	<53353524.9020605@freescale.com> <20140328100158.042a3d68@ipc1.ka-ro> <533541DE.7020606@freescale.com>
In-Reply-To: <533541DE.7020606@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年03月28日 17:33, Huang Shijie 写道:
> 于 2014年03月28日 17:01, Lothar Waßmann 写道:
>> There is no need for the ROM code to access any other partition than
>> the bootloader itself. Thus Linux can perfectly well be booted from
> Assume the ROM only access the partition which contains the 
> bootloader, and
> the ROM does the swapping for the pages(but we do not do the swapping 
> to these pages),
I mean the kernel do not do the swapping when we burn the uboot to the NAND.

thanks
Huang Shijie
>
> what will happen?
>
>


