Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKKEim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:38:42 -0500
Received: from mail.eperm.de ([89.247.134.16]:54331 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbaKKEik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:38:40 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "'Sandy Harris'" <sandyinchina@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: zeroization of buffers
Date: Tue, 11 Nov 2014 05:36:16 +0100
Message-ID: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

as discussed, these patches use the memzero_explicit function that is
yet to be integrated into the cryptodev-2.6 tree.

Stephan Mueller (2):
  crypto: AF_ALG - zeroize message digest buffer
  crypto: AF_ALG - zeroize IV buffer

 crypto/algif_hash.c     | 2 ++
 crypto/algif_skcipher.c | 1 +
 2 files changed, 3 insertions(+)

-- 
2.1.0


