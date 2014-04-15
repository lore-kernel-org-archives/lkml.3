Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140AbaDOEgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:36:05 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:14233
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbaDOEgB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:36:01 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz9371I542I1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h17326ah8275dh1de097h186068hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h262fh268bh26d3h906i2673i1155h)
From: Harini Katakam <harini.katakam@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Brown <broonie@kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>
Subject: RE: linux-next: build failure after merge of the spi tree
Thread-Topic: linux-next: build failure after merge of the spi tree
Thread-Index: AQHPWFDgxkXss89zqkCopYHuEJpkgZsSFYcw
Date: Tue, 15 Apr 2014 04:35:54 +0000
References: <20140415121703.055d54d52e9d2d325e9987f0@canb.auug.org.au>
In-Reply-To: <20140415121703.055d54d52e9d2d325e9987f0@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <77441af4-d070-4056-ae5d-ccfc945d9b1d@CH1EHSMHS018.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen/Mark,

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Tuesday, April 15, 2014 7:47 AM
> To: Mark Brown
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Harini
> Katakam
> Subject: linux-next: build failure after merge of the spi tree
> 
> Hi Mark,
> 
> After merging the spi tree, today's linux-next build (x86_64_allmodconfig)
> failed like this:
> 
> drivers/spi/spi-cadence.c: In function 'cdns_spi_write':
> drivers/spi/spi-cadence.c:135:2: error: implicit declaration of function
> 'writel_relaxed' [-Werror=implicit-function-declaration]
>   writel_relaxed(val, xspi->regs + offset);
>   ^
> 

I'm sorry - I just noticed that Soren's patches for I2C also gave a similar warning:
http://patchwork.ozlabs.org/patch/337285/

I will send a patch adding dependency on ARCH_ZYNQ.
Please let me know if you have a better suggestion.

Regards,
Harini


