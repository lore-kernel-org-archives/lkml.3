Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3GIIHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:07:07 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:16420
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686Ab3GIIG7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:06:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51DBC58D.90002@freescale.com>
Date: Tue, 9 Jul 2013 16:10:53 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <grant.likely@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] of: match the compatible in the order set by the dts
 file
References: <1373013818-11365-1-git-send-email-b32955@freescale.com> <20130709070541.GQ516@pengutronix.de> <51DBBFDA.70302@freescale.com> <20130709075124.GR516@pengutronix.de>
In-Reply-To: <20130709075124.GR516@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年07月09日 15:51, Sascha Hauer 写道:
> On Tue, Jul 09, 2013 at 03:46:34PM +0800, Huang Shijie wrote:
>> 于 2013年07月09日 15:05, Sascha Hauer 写道:
>>> Why don't you set the matching order in the driver the way you want it
>>> to be, i.e.:
>>>
>>> 	{ .compatible = "fsl,imx6q-uart", ... },
>>> 	{ .compatible = "fsl,imx21-uart", ... },
>>> 	{ .compatible = "fsl,imx1-uart", ... },
>>>
>> yes. i can set it like this.
>>
>> but this method looks like a ugly workaround.
> If a driver has different ways of supporting a single device, then
> putting the preferred or most feature rich on top doesn't look very ugly
> to me.
this method makes it much _coupled_ between the driver and the dts file.

IMHO, it's an unnecessary _burden_ to the driver programmer:
    he should puts the most feature compatible on the top.

it's much graceful if we let the driver programmer be transparent about 
this.

thanks
Huang Shijie







