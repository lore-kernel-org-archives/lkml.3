Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3KDNRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:17:12 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:37463
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab3KDNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:17:11 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 4 Nov 2013 21:17:41 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rob Herring <robherring2@gmail.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rostislav Lisovy <lisovy@gmail.com>,
        Silvio F <silvio.fricke@gmail.com>
Subject: Re: linux-next: manual merge of the dt-rh tree with the imx-mxs tree
Message-ID: <20131104131739.GC24970@S2101-09.ap.freescale.net>
References: <20131104152739.92ae486e7d418221c6a48a1e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131104152739.92ae486e7d418221c6a48a1e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 03:27:39PM +1100, Stephen Rothwell wrote:
> Hi Rob,
> 
> Today's linux-next merge of the dt-rh tree got a conflict in
> Documentation/devicetree/bindings/vendor-prefixes.txt between commit
> 064d7f6c985a ("ARM: dts: Add vendor prefix for Voipac Technologies
> s.r.o") from the imx-mxs tree and commit d6c3073e7fb5 ("DT: sort
> vendor-prefixes.txt") from the dt-rh tree.

Hi Rob,

Would you like to apply the patch "ARM: dts: Add vendor prefix for
Voipac Technologies s.r.o" on your tree, so that we can save this
conflict?  If so, I will drop the patch from my tree.  Just let me know.

Shawn

