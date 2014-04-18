Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067AbaDRVk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:40:59 -0400
Received: from mout.web.de ([212.227.17.11]:56321 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbaDRVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:40:47 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH v2 0/2] kconfig: Remove bad inference rules expr_eliminate_dups2()
Date: Fri, 18 Apr 2014 23:33:55 +0200
Message-ID: <6889353.LzkExyTh9u@tacticalops>
User-Agent: KMail/4.12.3 (Linux/3.12.13-gentoo-gnu; KDE/4.12.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:xjhpHen6ME1bELzP4ogBbxBGqFT1bRcGcq6gqFNyM9zvdUU24+O
 tGAI3D94P+00F40RiXr1WKc1BvPwysXToMco80epMCtlnj9qWq0ZxONFdINKaOn/PtfvLZD
 1Wvshhm3dSFhvZrPKL27dLNAwOV/sxPckjzr25nWQ0ZAPnQJdC8ZWezGQXsSbqY66q+WSbH
 d8uBXGJhXSKSa54m6/nfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, I have not seen any answers to the first version of this patch.
Accordingly, v2 contains only few changes.

PATCH 1: Remove expr_eliminate_dups2() and other related code.
This does not seem to actually affect the behaviour when using Kconfig files
from the mainline kernel. But there is a slight possibility that there are
configuration files in other branches or in other projects that use the Linux
Kernel configuration system that may be affected or may even rely on the
behaviour. So, there is a small chance to break something somewhere (on the
other hand, there is also a small chance to fix something somewhere). Maybe
some warning should be documented in case this patch gets accepted?
v2 updates line numbers after latest changes

PATCH 2: Fix some comments when touching expr.c anyway. No code changes.
v2 additionally converts C99 style comments to traditional ones.

Martin Walch (2):
  kconfig: completely remove expr_eliminate_dups2() and related code
  kconfig: trivial - adjust comments

 scripts/kconfig/expr.c | 146 +++++++------------------------------------------
 scripts/kconfig/expr.h |   3 -
 2 files changed, 19 insertions(+), 130 deletions(-)

-- 
1.8.3.2

