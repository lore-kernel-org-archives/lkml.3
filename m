Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaBRQcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:32:31 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:55332
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbaBRQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:32:30 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Message-ID: <53038B4B.7020706@freescale.com>
Date: Tue, 18 Feb 2014 13:33:15 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <festevam@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pfuze100-regulator: Revert "regulator: pfuze100: Use
 of_get_child_by_name"
References: <1392738636-29877-1-git-send-email-fabio.estevam@freescale.com> <CAK9yfHykaoap7Dz+fsZgReRoXW_GsKvmZX7RDGqknd1_o3R50g@mail.gmail.com>
In-Reply-To: <CAK9yfHykaoap7Dz+fsZgReRoXW_GsKvmZX7RDGqknd1_o3R50g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 01:28 PM, Sachin Kamat wrote:
> On 18 February 2014 21:20, Fabio Estevam <fabio.estevam@freescale.com> wrote:
>> Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
>> the following probe failure:
>>
>> pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
>> pfuze100-regulator 1-0008: FAB: 0, FIN: 0
>> pfuze100-regulator 1-0008: regulators node not found
>> pfuze100-regulator: probe of 1-0008 failed with error -22
>>
>> Revert the offending commit so that we can probe the regulator successfully.
>
> I wonder what is different in this case from the ones that I already
> have working
> that is causing this to fail. Can you please tell me which dts file
> you have used
> so that I can see if the way the node is defined is anything different.

The dts I am using is arch/arm/boot/dts/imx6qdl-sabresd.dtsi, and I 
build imx6q-sabresd.dtb from linux-next.

Regards,

Fabio Estevam

