Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaBMM5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:57:08 -0500
Received: from mout.web.de ([212.227.17.12]:54446 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbaBMM5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:57:07 -0500
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 0/2] kconfig: Remove bad inference rules expr_eliminate_dups2()
Date: Thu, 13 Feb 2014 13:57:03 +0100
Message-ID: <2015312.oM82sdiqfh@tacticalops>
User-Agent: KMail/4.12.2 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:49FJgLDUoK4Aq83PMfDWU+fwWKgs4sZ0dBXMiazPaAdlBdw/Tck
 Vod8W0AgpMXFGWba6C/zA6vkwCaiVn7HUsx8r49lCZjiGyCUR8o4iSI8eh64GpwzDWAjeF9
 m5rU7JUfMiXrx1muMvx7payR0G+etDIoh+PR9XA0ClX1ES5uaDQ0VvomZyf/srFQmxLZDED
 5mDE1s5cKzRyYLmWLrbfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Thu, 13 Feb 2014 12:22:18 +0100
Subject: [PATCH 0/2] kconfig: Remove bad inference rules expr_eliminate_dups2()

PATCH 1: Removes expr_eliminate_dups2() and other related code.
This does not seem to actually affect the behaviour when using Kconfig files
from the mainline kernel. But there is a slight possibility that there are
configuration files in other branches or in other projects that use the Linux
Kernel configuration system that may be affected or may even rely on the
behaviour. So, there is a small chance to break something somewhere (on the
other hand, there is also a small chance to fix something somewhere). Maybe
some warning should be documented in case this patch gets accepted?

PATCH 2: Fix some comments when touching expr.c anyway. No code changes.

Martin Walch (2):
  kconfig: completely remove expr_eliminate_dups2() and related code
  kconfig: trivial - adjust comments

 scripts/kconfig/expr.c | 112 +------------------------------------------------
 scripts/kconfig/expr.h |   3 --
 2 files changed, 2 insertions(+), 113 deletions(-)

-- 
1.8.3.2


