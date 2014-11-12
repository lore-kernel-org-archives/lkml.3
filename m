Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbaKLEdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:33:11 -0500
Received: from mail.eperm.de ([89.247.134.16]:54472 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933630AbaKLEdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:33:07 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>, "David S. Miller" <davem@davemloft.net>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "Joy M. Latten" <jmlatten@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 00/13] crypto: Documentation of kernel crypto API
Date: Wed, 12 Nov 2014 05:22 +0100
Message-ID: <1800066.efQ8hkST4U@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
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

The documentation is provided in a DocBook whose output can be reviewed at:

http://www.chronox.de/crypto-API/index.html

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

Changes v3:
 * Replaced user space example code with reference to libkcapi as a reference
   implementation and a simple library hiding the Netlink details.
 * Converted all kernel documentation into a basis for a DocBook as suggested
   by Jonathan Corbet
 * Included (hopefully) all suggestions provided over the last two weeks

Stephan Mueller (13):
  crypto: Documentation - crypto API high level spec
  crypto: Documentation - compile crypto API spec
  crypto: Documentation - userspace interface spec
  crypto: Documentation - RNG API documentation
  crypto: Documentation - hash data structures
  crypto: Documentation - AHASH API documentation
  crypto: Documentation - SHASH API documentation
  crypto: Documentation - cipher data structures
  crypto: Documentation - ABLKCIPHER API documentation
  crypto: Documentation - AEAD API documentation
  crypto: Documentation - BLKCIPHER API documentation
  crypto: Documentation - CIPHER API documentation
  crypto: Documentation - HASH API documentation

 Documentation/DocBook/Makefile                |    2 +-
 Documentation/DocBook/crypto-API.tmpl         | 1253 +++++++++++++++++++++++++
 Documentation/crypto/crypto-API-userspace.txt |  205 ++++
 include/crypto/hash.h                         |  487 ++++++++++
 include/crypto/rng.h                          |   80 ++
 include/linux/crypto.h                        | 1099 +++++++++++++++++++++-
 6 files changed, 3122 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/DocBook/crypto-API.tmpl
 create mode 100644 Documentation/crypto/crypto-API-userspace.txt

-- 
2.1.0


