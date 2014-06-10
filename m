Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaFJOdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:33:35 -0400
Received: from mout.web.de ([212.227.15.14]:49178 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaFJOde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:33:34 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>
Subject: [RESEND PATCH v2 0/2] kconfig: Remove bad inference rules expr_eliminate_dups2()
Date: Tue, 10 Jun 2014 16:31:13 +0200
Message-ID: <3491939.FtiyjGE4Of@tacticalops>
User-Agent: KMail/4.13.1 (Linux/3.12.21-gentoo-r1-gnu; KDE/4.13.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:lMAoYaThQz3x4LIIhsZ1Uhp7CJvIdnc+k/TfhGCmKxir3PUuHk0
 Zs4V2YPg6UGHwxhHNH1ZBYlcZPjN3cvAMfaiNrtjvGgsHHYZVPsSjol26C5JR/pLg2Fxiyn
 FdF8Pr5Ma/F6Nenvudlba7GgSa+B8eQjOzIGBcSaaM8ek4jA7N+9kksKSGnrgb1pj1Vl38p
 R3B9hO1FdB8sh8WHelHfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third time I send this patch. As I think it is an obvious
improvement, but has not been applied, please tell me what is wrong with
this patch and what I can do better.

PATCH 1: Remove expr_eliminate_dups2() and other related code.
This does not seem to actually affect the behaviour when using Kconfig files
from the mainline kernel. But there is a slight possibility that there are
configuration files in other branches or in other projects that use the Linux
Kernel configuration system that may be affected or may even rely on the
behaviour (although I did not find such a case when doing a quick check on
busybox, uClibc and openwrt). So, there is a tiny chance to break some
very exotic case (on the other hand, it is plausible that it actually fixes
any such case).

PATCH 2: When touching expr.c anyway, fix some comments and convert C99 style
comments to traditional ones.

Martin Walch (2):
  kconfig: completely remove expr_eliminate_dups2() and related code
  kconfig: trivial - adjust comments

 scripts/kconfig/expr.c | 146 +++++++------------------------------------------
 scripts/kconfig/expr.h |   3 -
 2 files changed, 19 insertions(+), 130 deletions(-)

-- 
1.8.5.5

