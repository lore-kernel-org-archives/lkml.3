Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3G2Ltm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:49:42 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:54279 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541Ab3G2Ltf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:49:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I15bfK542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Chereji Marian-Cornel-R27762 <R27762@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grigore Sebastian-SGRIGOR1 <sgrigor1@freescale.com>,
        Schmitt Richard-B43082 <B43082@freescale.com>,
        Fleming Andy-AFLEMING <afleming@freescale.com>
Subject: RE: [PATCH] lib: Add CRC64 ECMA module
Thread-Topic: [PATCH] lib: Add CRC64 ECMA module
Thread-Index: AQHOikuZv1zs1z6XGEqbmGQao9hE/5l7jUBg
Date: Mon, 29 Jul 2013 11:49:31 +0000
Message-ID: <4B6ACA9E2957BC4EBAA02AF13568C81B03CA7BC4@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1373619386-29550-1-git-send-email-marian.chereji@freescale.com>
 <20130726150043.67b248c9d5d93c00ed30ebc8@linux-foundation.org>
In-Reply-To: <20130726150043.67b248c9d5d93c00ed30ebc8@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.171.73.194]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

we have an IP Acceleration driver for Freescale network processors
which is using this CRC64. However, it still needs some work in
order for it to become upstreamable.

Thought this CRC64 could helps others in the meantime since it doesn't
have anything specific to do with our driver.

Best regards,
Marian.


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Saturday, July 27, 2013 1:01 AM
To: Chereji Marian-Cornel-R27762
Cc: linux-kernel@vger.kernel.org; Grigore Sebastian-SGRIGOR1; Schmitt Richard-B43082; Fleming Andy-AFLEMING
Subject: Re: [PATCH] lib: Add CRC64 ECMA module

On Fri, 12 Jul 2013 11:56:26 +0300 Marian Chereji <marian.chereji@freescale.com> wrote:

> Added implementation of CRC64 ECMA checksum.
> 
> Signed-off-by: Marian Chereji <marian.chereji@freescale.com>
> Reviewed-by: Varvara Andrei-B21317 <andrei.varvara@freescale.com>
> Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
> ---
>  include/linux/crc64_ecma.h |   56 +++++++
>  lib/Kconfig                |    7 +
>  lib/Makefile               |    1 +
>  lib/crc64_ecma.c           |  341 ++++++++++++++++++++++++++++++++++++++++++++

Presumably you have some code which will need this library feature?

What code is that, and what is its status?


