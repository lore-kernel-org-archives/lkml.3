Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaCTKzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:55:19 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:50024
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659AbaCTKzR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:55:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h2668h1155h)
Message-ID: <532AC950.6070108@freescale.com>
Date: Thu, 20 Mar 2014 18:56:16 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: <y@KARO-electronics.de>, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <b47714@freescale.com>
Subject: Re: [PATCH] mtd: gpmi: make blockmark swapping optional
References: <1395235406-13449-1-git-send-email-y>	<532AB1A2.9010702@freescale.com>	<20140320102153.7106f915@ipc1.ka-ro>	<532AB94D.1050406@freescale.com> <20140320110914.731db7cf@ipc1.ka-ro>
In-Reply-To: <20140320110914.731db7cf@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年03月20日 18:09, Lothar Waßmann 写道:
> This can be disabled by parameter in the FCB (at least according to
> the i.MX6 reference Manual):
from imx28's reference manual, there is not such bit in the FCB to 
disable the
swapping. But you are disabling the swapping in the imx28's DTS file, 
isn't it?

I think it is dangerous.



> |DISBBM 172 4 If 0 ROM will swap BadBlockMarkerByte with
> |             metadata[0] after reading a page using BCH40.
> |             If the value set is 1 then ROM will not do
> |             swapping
>
>
I will consult with our ROM colleague about this DISBBM bit.

I am not sure if the ROM still do the swapping for the uboot when we set 
DISBBM bit.

thanks
Huang Shijie


