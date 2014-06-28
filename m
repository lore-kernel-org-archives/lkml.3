Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaF1UPC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:15:02 -0400
Received: from mail.eperm.de ([89.247.134.16]:49795 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaF1UPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:15:00 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] DRBG: Fixes for sparse tool reports
Date: Sat, 28 Jun 2014 21:57:49 +0200
Message-ID: <4927386.WYHrRe3NJm@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches cover requested changes based on the sparse tool test
run and suggestions by peer reviewers.

In addition, a patch to make the CTR DRBG more efficient is added.

Stephan Mueller (4):
  DRBG: use of kernel linked list
  DRBG: cleanup of preprocessor macros
  DRBG: Fix format string for debugging statements
  DRBG: Call CTR DRBG DF function only once

 crypto/drbg.c         | 302 ++++++++++++++++++++++++++++----------------------
 include/crypto/drbg.h |   7 +-
 2 files changed, 174 insertions(+), 135 deletions(-)

-- 
1.9.3


