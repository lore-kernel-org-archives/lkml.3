Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab3GZEEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:04:22 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:21380
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab3GZEET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:04:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zzbb2dI98dI9371I542I1432I14ffIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 26 Jul 2013 12:03:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Zhu Richard-R65037 <r65037@freescale.com>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: linux-next: Tree for Jul 25 (ahci_imx.c)
Message-ID: <20130726040349.GA29268@S2101-09.ap.freescale.net>
References: <20130725151253.8b9b53b3a3cf6cacd501dc54@canb.auug.org.au>
 <51F16F17.4030002@infradead.org>
 <0E83723C55F66F43A6041464FE31119D3487F2@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0E83723C55F66F43A6041464FE31119D3487F2@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 03:46:42AM +0000, Zhu Richard-R65037 wrote:
> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@infradead.org] 
> Sent: Friday, July 26, 2013 2:32 AM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Zhu Richard-R65037
> Subject: Re: linux-next: Tree for Jul 25 (ahci_imx.c)
> 
> On 07/24/13 22:12, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130724:
> > 
> 
> on i386:
> 
> # CONFIG_MFD_SYSCON is not set
> 
> 
> when ahci_imx.c is built as a loadable module:
> 
> ERROR: "syscon_regmap_lookup_by_compatible" [drivers/ata/ahci_imx.ko] undefined!
> 
> or when it is builtin:
> 
> ahci_imx.c:(.text+0x182e54): undefined reference to `syscon_regmap_lookup_by_compatible'
> 

We should have it depend on MFD_SYSCON.

Shawn

