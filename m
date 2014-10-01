Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaJASnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:43:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43470 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaJASnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:43:07 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/4] integrity: few code cleanups
Date: Wed,  1 Oct 2014 21:43:06 +0300
Message-Id: <cover.1412188590.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is few simple code cleanups.
Please refer to the patch descriptions for details.
They previously were posted on linux-ima-devel mailing list
and feedback was addressed.

- Dmitry

Dmitry Kasatkin (4):
  integrity: add missing '__init' keyword for integrity_init_keyring()
  evm: skip replacing EVM signature with HMAC on read-only filesystem
  ima: check appraisal flag in the ima_file_free() hook
  ima: use path names cache

 security/integrity/digsig.c       |  2 +-
 security/integrity/evm/evm_main.c | 11 ++++++++---
 security/integrity/iint.c         |  3 ---
 security/integrity/ima/ima_api.c  |  4 ++--
 security/integrity/ima/ima_main.c |  5 +++--
 security/integrity/integrity.h    |  5 +----
 6 files changed, 15 insertions(+), 15 deletions(-)

-- 
1.9.1

