Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3JBFYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:24:47 -0400
Received: from mout.web.de ([212.227.17.12]:63025 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab3JBFYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:24:44 -0400
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
Subject: [PATCH 4/4] kconfig: remove unused definition from scanner
Date: Wed, 02 Oct 2013 07:24:40 +0200
Message-ID: <6249343.9Mjtul3lu5@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:JmlvLkRN36NWdQvaXaPP8HfZn8whS7f0yiEx5oMSEztindNY3Xf
 Vqn64lMfJ84X0yoIu7BealDQL3zS+5P8KkA6UDoHBAYo9L45AmsEe/hORB8ygi7gAzVmm5c
 sPaDcQWwaVXCyi5phNuGXdDujYDF8mPeeUeR+4/8guXt/LQIpJ1x/Uwfo3yGg+/SkocRusd
 m9/GZ2MxCwte0n8Ccmrpw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Wed, 2 Oct 2013 06:58:46 +0200
Subject: [PATCH 4/4] kconfig: remove unused definition from scanner

The definition ws [ \n\t] is not used anywhere. Drop it to avoid confusion.

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/zconf.l | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index 6555a47..1a9f53e 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -68,7 +68,6 @@ static void alloc_string(const char *str, int size)
 }
 %}
 
-ws	[ \n\t]
 n	[A-Za-z0-9_]
 
 %%
-- 
1.8.1.5


