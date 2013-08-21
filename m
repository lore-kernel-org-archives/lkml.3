Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3HUEUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:20:20 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:54624 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524Ab3HUEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:20:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zcb8kzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h1155h)
Message-ID: <5214401D.8010402@freescale.com>
Date: Wed, 21 Aug 2013 12:20:45 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Sascha Hauer <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: imx6q: refactor some ldb related clocks
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com> <1376987932-5540-2-git-send-email-Ying.Liu@freescale.com> <CAOMZO5Afjp-zPzUaNE63L7Y2LjZbSrLupAJ_jFnf1Gg1+hx0Nw@mail.gmail.com>
In-Reply-To: <CAOMZO5Afjp-zPzUaNE63L7Y2LjZbSrLupAJ_jFnf1Gg1+hx0Nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 11:40 PM, Fabio Estevam wrote:
> On Tue, Aug 20, 2013 at 5:38 AM, Liu Ying <Ying.Liu@freescale.com> wrote:
> 
>> diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
>> index 5a90a72..90e923e 100644
>> --- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
>> +++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
>> @@ -89,8 +89,6 @@ clocks and IDs.
>>         gpu3d_shader            74
>>         ipu1_podf               75
>>         ipu2_podf               76
>> -       ldb_di0_podf            77
>> -       ldb_di1_podf            78
>>         ipu1_di0_pre            79
>>         ipu1_di1_pre            80
>>         ipu2_di0_pre            81
> 
> This causes a 'hole' in the clock numbering scheme: 74, 75, 76, 79, 80, etc
> 

I find there is a 'hole' in Documentation/devicetree/bindings/clock/imx5-clock.txt as well.
The 'hole' was taken by tve_di(26) clock before.

Is this more acceptable?

ldb_di0_podf_unused            77
ldb_di1_podf_unused            78

Liu Ying

