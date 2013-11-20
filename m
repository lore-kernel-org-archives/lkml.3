Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3KTQUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:20:35 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:59420
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab3KTQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:20:32 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh839h944hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h1155h)
X-WSS-ID: 0MWKLBE-07-5KH-02
X-M-MSG: 
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <herbert@gondor.hengli.com.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] AMD Cryptographic Coprocessor support
Date: Wed, 20 Nov 2013 10:20:10 -0600
Message-ID: <5441273.HtAtgCrPKB@tlendack-t1>
Organization: Advanced Micro Devices, Inc.
User-Agent: KMail/4.8.5 (Linux/3.2.0-56-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

Is the crypto tree the right tree to go through for this support
or would you prefer I go through another tree?

Thanks,
Tom

On Tuesday, November 12, 2013 11:45:59 AM Tom Lendacky wrote:
> Resending because of typo in mailing list address...
> 
> The following series implements support for the AMD Cryptographic
> Coprocessor (CCP).  The AMD CCP provides hardware encryption, hashing
> and other related operations.
> 
> This patch series is based on the 3.12 kernel.
> 
> ---
> 
> Tom Lendacky (10):
>       crypto: authenc - Find proper IV address in ablkcipher callback
>       crypto: scatterwalk - Set the chain pointer indication bit
>       crypto: CCP device driver and interface support
>       crypto: crypto API interface to the CCP device driver
>       crypto: CCP AES crypto API support
>       crypto: CCP AES CMAC mode crypto API support
>       crypto: CCP XTS-AES crypto API support
>       crypto: CCP SHA crypto API support
>       crytpo: CCP device driver build files
>       crypto: CCP maintainer information
> 
> 
>  MAINTAINERS                              |    7
>  crypto/authenc.c                         |    7
>  drivers/crypto/Kconfig                   |   12
>  drivers/crypto/Makefile                  |    1
>  drivers/crypto/ccp/Kconfig               |   23
>  drivers/crypto/ccp/Makefile              |   10
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c |  355 +++++
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c  |  285 ++++
>  drivers/crypto/ccp/ccp-crypto-aes.c      |  375 ++++++
>  drivers/crypto/ccp/ccp-crypto-main.c     |  432 ++++++
>  drivers/crypto/ccp/ccp-crypto-sha.c      |  497 +++++++
>  drivers/crypto/ccp/ccp-crypto.h          |  191 +++
>  drivers/crypto/ccp/ccp-dev.c             |  582 +++++++++
>  drivers/crypto/ccp/ccp-dev.h             |  272 ++++
>  drivers/crypto/ccp/ccp-ops.c             | 2020
> ++++++++++++++++++++++++++++++ drivers/crypto/ccp/ccp-pci.c             | 
> 360 +++++
>  include/crypto/scatterwalk.h             |    1
>  include/linux/ccp.h                      |  525 ++++++++
>  18 files changed, 5952 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/crypto/ccp/Kconfig
>  create mode 100644 drivers/crypto/ccp/Makefile
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-cmac.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-xts.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-main.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-sha.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto.h
>  create mode 100644 drivers/crypto/ccp/ccp-dev.c
>  create mode 100644 drivers/crypto/ccp/ccp-dev.h
>  create mode 100644 drivers/crypto/ccp/ccp-ops.c
>  create mode 100644 drivers/crypto/ccp/ccp-pci.c
>  create mode 100644 include/linux/ccp.h
-- 
Tom

Thomas Lendacky
Advanced Micro Devices, Inc.

