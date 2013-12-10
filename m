Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3LJQig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:38:36 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:51044
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194Ab3LJQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:33 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MXLNF0-08-H2M-02
X-M-MSG: 
Subject: [PATCH 0/3] crypto: ccp - code fixes/cleanup
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 10:38:27 -0600
Message-ID: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements fixes and cleanup for some reported
errors and suggestions (sparse errors, randconfig build errors and
pr_err usage).

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (3):
      crypto: ccp - Fix sparse warnings in ccp-crypto-sha.c
      crypto: ccp - CCP Kconfig fixes
      crypto: ccp - Remove user triggerable pr_err calls


 drivers/crypto/Kconfig                   |    2 +-
 drivers/crypto/ccp/Kconfig               |    1 +
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    4 +---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |   12 +++---------
 drivers/crypto/ccp/ccp-crypto-aes.c      |   12 +++---------
 drivers/crypto/ccp/ccp-crypto-sha.c      |    8 ++++----
 drivers/crypto/ccp/ccp-crypto.h          |    2 +-
 7 files changed, 14 insertions(+), 27 deletions(-)

-- 
Tom Lendacky

