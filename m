Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3JBFYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:24:18 -0400
Received: from mout.web.de ([212.227.17.11]:56306 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3JBFYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:24:16 -0400
From: Martin Walch <walch.martin@web.de>
Cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        Alan Cox <alan@linux.intel.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4]kconfig: minor cleanups and corrections
Date: Wed, 02 Oct 2013 07:24:11 +0200
Message-ID: <2239119.8z7hSRUtxP@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:UFxWv1314kjlKHWYrZMV+/4UWI8liV9EUtiXeCl77bFGBLFRH6p
 KK/8Ss2vLELIoKKcB4sVrsIn94qjsSHM0apd4aoiptfhdTS1lnBpjso5SHanvmslRqbthyc
 Plz4TZZMYJbWooGXlp1ZNKmersTI+Ku3eU86kMKy7OX0uFMQ918pyAkrErJKhA5Wg2sxY+i
 OF8sM1dxxZotB4Xdi7kTg==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

these are some simple fixes to correct minor things I came across while reading the code.

Martin Walch (4):
  kconfig: add short explanation to SYMBOL_WRITE
  kconfig: trivial: fix typos in comments
  kconfig: adjust warning message for conflicting types
  kconfig: remove unused definition from scanner

 scripts/kconfig/expr.h   | 2 +-
 scripts/kconfig/mconf.c  | 2 +-
 scripts/kconfig/menu.c   | 4 ++--
 scripts/kconfig/symbol.c | 2 +-
 scripts/kconfig/zconf.l  | 1 -
 5 files changed, 5 insertions(+), 6 deletions(-)

-- 
1.8.1.5

