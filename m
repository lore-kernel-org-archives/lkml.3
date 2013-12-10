Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3LJPfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:35:04 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:23457
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab3LJPe5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:34:57 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic89bh148cI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh839h93fhd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MXLKGY-08-B4X-02
X-M-MSG: 
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: randconfig build error with next-20131210, in drivers/crypto/ccp/ccp-pci.c
Date: Tue, 10 Dec 2013 09:34:48 -0600
Message-ID: <1785749.ip5jsEzFz7@tlendack-t1>
Organization: Advanced Micro Devices, Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com>
References: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday, December 10, 2013 07:21:36 AM Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/crypto/ccp/ccp-pci.c: In function ‘ccp_get_msix_irqs’:
> drivers/crypto/ccp/ccp-pci.c:44:20: error: array type has incomplete
> element type
> drivers/crypto/ccp/ccp-pci.c:48:18: error: negative width in bit-field
> ‘<anonymous>’
> drivers/crypto/ccp/ccp-pci.c:51:2: error: implicit declaration of
> function ‘pci_enable_msix’ [-Werror=implicit-function-declaration]
> drivers/crypto/ccp/ccp-pci.c:76:2: error: implicit declaration of
> function ‘pci_disable_msix’ [-Werror=implicit-function-declaration]
> drivers/crypto/ccp/ccp-pci.c:44:20: warning: unused variable
> ‘msix_entry’ [-Wunused-variable]
> drivers/crypto/ccp/ccp-pci.c: In function ‘ccp_get_msi_irq’:
> drivers/crypto/ccp/ccp-pci.c:89:2: error: implicit declaration of
> function ‘pci_enable_msi’ [-Werror=implicit-function-declaration]
> drivers/crypto/ccp/ccp-pci.c:102:2: error: implicit declaration of
> function ‘pci_disable_msi’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/crypto/ccp/ccp-pci.o] Error 1

Thanks for finding this, I'll update to the Kconfig to add PCI to
the 'depends on' statement.

Tom

