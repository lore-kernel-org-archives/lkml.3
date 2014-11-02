Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaKBUoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:44:22 -0500
Received: from mail.eperm.de ([89.247.134.16]:54259 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaKBUoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:44:10 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 00/11] crypto: Documentation of kernel crypto API
Date: Sun, 02 Nov 2014 21:34:22 +0100
Message-ID: <6375771.bx7QqLJLuR@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch set adds documentation files under Documentation/crypto/
covering the high-level description of the API. In addition, it contains
source code comments added to the header files of the kernel crypto API
documenting the API functions.

Changes v2:
 * Split out the user space documentation into separate document including
   the user space example code
 * Change the license of the user space interface code to match the license
   of the code that I used as a reference.
 * Addition of a precise pointer to the user space interface code reference
   code.
 * Add a missing memset(0) to the user space example code.
 * Move the API function call documentation into the header files in the hope
   for a better maintainability.
 * Merge the developer-related documentation from Marek Vasut 

Stephan Mueller (11):
  crypto: Documentation - crypto API high level spec
  crypto: Documentation - userspace interface spec
  crypto: Documentation - RNG API documentation
  crypto: Documentation - AHASH API documentation
  crypto: Documentation - SHASH API documentation
  crypto: Documentation - documentation of crypto_alg
  crypto: Documentation - ABLKCIPHER API documentation
  crypto: Documentation - AEAD API documentation
  crypto: Documentation - BLKCIPHER API documentation
  crypto: Documentation - CIPHER API documentation
  crypto: Documentation - HASH API documentation

 Documentation/crypto/crypto-API-spec.txt      |  721 ++++++++++++++
 Documentation/crypto/crypto-API-userspace.txt |  662 +++++++++++++
 include/crypto/hash.h                         |  421 +++++++++
 include/crypto/rng.h                          |  113 +++
 include/linux/crypto.h                        | 1239 ++++++++++++++++++++++++-
 5 files changed, 3136 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/crypto/crypto-API-spec.txt
 create mode 100644 Documentation/crypto/crypto-API-userspace.txt

-- 
2.1.0


