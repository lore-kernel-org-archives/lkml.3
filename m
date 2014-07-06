Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaGFAqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 20:46:22 -0400
Received: from mail.eperm.de ([89.247.134.16]:41603 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaGFAqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 20:46:20 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: joe@perches.com, dan.carpenter@oracle.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, fengguang.wu@intel.com,
        Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, aris@redhat.com
Subject: [PATCH 0/6] DRBG: Rebasing unapplied patches
Date: Sun, 06 Jul 2014 02:22:29 +0200
Message-ID: <2266932.bfVPMOTOeI@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset superseeds the patch sets submitted with [1] and [2]. It
rebases all non-applied patches to the current Herbert Xu's
cryptodev-2.6 tree.

[1] https://lkml.org/lkml/2014/6/28/497
[2] https://lkml.org/lkml/2014/7/1/332

Stephan Mueller (6):
  DRBG: cleanup of preprocessor macros
  DRBG: Fix format string for debugging statements
  DRBG: Call CTR DRBG DF function only once
  DRBG: Select correct DRBG core for stdrng
  DRBG: Mix a time stamp into DRBG state
  DRBG: HMAC-SHA1 DRBG has crypto strength of 128 bits

 crypto/drbg.c         | 134 +++++++++++++++++++++++++++++---------------------
 include/crypto/drbg.h |   2 +-
 2 files changed, 78 insertions(+), 58 deletions(-)

-- 
1.9.3


