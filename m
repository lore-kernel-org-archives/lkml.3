Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbaGDODp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:03:45 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47135 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaGDODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:03:43 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 0/2] crypto: qce: fix few sparse warnings
Date: Fri,  4 Jul 2014 17:03:28 +0300
Message-Id: <1404482610-25608-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

Here are sparse fixes for Qualcomm crypto driver reported here [1].
The patches are based on cryptodev-2.6 tree.

regards,
Stan

[1] https://lists.01.org/pipermail/kbuild-all/2014-July/005429.html

Stanimir Varbanov (2):
  crypto: qce: fix sparse warnings
  crypto: qce: add dependancy to Kconfig

 drivers/crypto/Kconfig      |    1 +
 drivers/crypto/qce/common.c |   15 +++++++++------
 drivers/crypto/qce/common.h |    2 +-
 drivers/crypto/qce/sha.c    |   20 ++++++++++----------
 4 files changed, 21 insertions(+), 17 deletions(-)

