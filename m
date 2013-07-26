Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab3GZEBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:01:54 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:19916
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3GZEBu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:01:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I542I1432I14ffIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Zhu Richard-R65037 <r65037@freescale.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: RE: linux-next: Tree for Jul 25 (ahci_imx.c)
Thread-Topic: linux-next: Tree for Jul 25 (ahci_imx.c)
Thread-Index: AQHOiWVuR7qfxy8/30GbgPkEHfnAsZl2Ukxw
Date: Fri, 26 Jul 2013 03:46:42 +0000
Message-ID: <0E83723C55F66F43A6041464FE31119D3487F2@039-SN2MPN1-011.039d.mgd.msft.net>
References: <20130725151253.8b9b53b3a3cf6cacd501dc54@canb.auug.org.au>
 <51F16F17.4030002@infradead.org>
In-Reply-To: <51F16F17.4030002@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy:
Thanks for your kindly reminder.
I re-produced this issue at my side.
Now, I'm trying to find a proper method to fix it.

Best Regards
Richard Zhu


-----Original Message-----
From: Randy Dunlap [mailto:rdunlap@infradead.org] 
Sent: Friday, July 26, 2013 2:32 AM
To: Stephen Rothwell
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Zhu Richard-R65037
Subject: Re: linux-next: Tree for Jul 25 (ahci_imx.c)

On 07/24/13 22:12, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130724:
> 

on i386:

# CONFIG_MFD_SYSCON is not set


when ahci_imx.c is built as a loadable module:

ERROR: "syscon_regmap_lookup_by_compatible" [drivers/ata/ahci_imx.ko] undefined!

or when it is builtin:

ahci_imx.c:(.text+0x182e54): undefined reference to `syscon_regmap_lookup_by_compatible'



Full randconfig file is attached.


-- 
~Randy

