Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3LKOv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:51:56 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:29048
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab3LKOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:51:53 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 12
X-BigFish: VPS12(zz98dI9371I148cI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz177df4h8275eh17326ah1de097h186068ha1495iz2dh839h944hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336hf3eih1155h)
X-WSS-ID: 0MXND4Z-08-NNT-02
X-M-MSG: 
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.4 01/25] crypto: scatterwalk - Set the chain pointer indication bit
Date: Wed, 11 Dec 2013 08:51:44 -0600
Message-ID: <2665532.GYRAgVKg91@tlendack-t1>
Organization: Advanced Micro Devices, Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131211020229.GB15638@kroah.com>
References: <20131210075930.808460227@linuxfoundation.org> <986457BC66A4884EBFFDEFEBEB20F84C0B1EBBAA@satlexdag04.amd.com> <20131211020229.GB15638@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday, December 10, 2013 06:02:29 PM Greg Kroah-Hartman wrote:
> On Tue, Dec 10, 2013 at 02:46:46PM +0000, Lendacky, Thomas wrote:
> > Hi Greg,
> > 
> > This patch is probably not needed in any of the stable branches, but if
> > you do add it you'll need to also include a patch that changes the use
> > of an sg_page to an sg_chain_ptr to prevent a BUG_ON when CONFIG_DEBUG_SG
> > is enabled (http://marc.info/?l=linux-crypto-vger&m=138627061905651&w=2).
> 
> You are referring to commit 389a5390583a18e45bc4abd4439291abec5e7a63 in
> Linus's tree, right?  It's in my queue to apply after 3.13-rc4 comes

Yes, that's the one.

Thanks,
Tom

> out, but I guess it's good to add it now as it is known that this is an
> issue to be resolved.
> 
> I'll go do that right now, thanks for letting me know.
> 
> greg k-h

