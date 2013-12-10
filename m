Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3LJPdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:33:42 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:20602
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab3LJPdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:33:39 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 12
X-BigFish: VPS12(zz98dI9371I148cI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh839h944hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336hf3eih1155h)
X-WSS-ID: 0MXLKEP-07-8C0-02
X-M-MSG: 
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: randconfig build error with next-20131210, in drivers/crypto/ccp
Date: Tue, 10 Dec 2013 09:33:26 -0600
Message-ID: <2432540.XbvglUb6sT@tlendack-t1>
Organization: Advanced Micro Devices, Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CA+r1ZhhmuJF=YLAjOkEfr8YzLHC+Mwe+ubgorjvK0KdZwheDEg@mail.gmail.com>
References: <CA+r1ZhhmuJF=YLAjOkEfr8YzLHC+Mwe+ubgorjvK0KdZwheDEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday, December 09, 2013 10:30:17 PM Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `ccp_init':
> /home/jim/linux/drivers/crypto/ccp/ccp-dev.c:402: undefined reference
> to `hwrng_register'
> drivers/built-in.o: In function `ccp_destroy':
> /home/jim/linux/drivers/crypto/ccp/ccp-dev.c:445: undefined reference
> to `hwrng_unregister'
> make: *** [vmlinux] Error 1

Thanks for finding this, I'll update the Kconfig to select HW_RANDOM.

Tom

