Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3JCR0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:26:48 -0400
Received: from mout.web.de ([212.227.17.12]:55369 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab3JCR0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:26:38 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] kconfig: cleanups, documentation updates, and one bug fix
Date: Thu, 03 Oct 2013 19:24:07 +0200
Message-ID: <3926659.JuuXvBGSjN@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:ijSnbetGV0/SaabfoTDHhqc6NHRLEQsCQMnWud9ZbrDzd365aA8
 tTkAZ4I1mvWxqxehtHR8Z/3UKXpv01UWrce6bG/pF70BngTz0f64LgRcRZP8gchkssX47R/
 PmiHKOm6IBDEWHwQE/dRFD2gX6adc8DcJajcLtCKMEsLpqBnm7LdsZi5LhIn8YZfJyttyTY
 koPs3MwvHARysPCFRUZ2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this second attempt, I tried to incorporate all replies I received for the
first version of this patch set:

PATCH 1: kconfig: add short explanation to SYMBOL_WRITE
 Ignore this one as long as there is no clear conclusion about the purpose
 of SYMBOL_WRITE. I only include it, so the patch numbers do not change and
 there is no "hole" in the patch set.

PATCH 2: kconfig: fix trivial typos and update mconf documentation
 In the first place, this corrected only three typos. Now this patch corrects
 all bad occurrences of "tell" instead of "tells" and fixes several more
 spelling mistakes. Furthermore some changes that have been made to mconf
 during the last years are now also updated in the documentation.

PATCH 3: kconfig: adjust warning message for conflicting types
 Now explicitely state that the second type is being ignored.

PATCH 4: kconfig: remove unused definition from scanner
 No changes since the first version.

PATCH 5: kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len
 As I do not think it is worth to make this a separate patch, I appended
 this fix for a bug that is only triggered by the search function of mconf.

Martin Walch (5):
  kconfig: add short explanation to SYMBOL_WRITE
  kconfig: fix trivial typos and update mconf documentation
  kconfig: adjust warning message for conflicting types
  kconfig: remove unused definition from scanner
  kconfig: fix bug in search results string: use strlen(gstr->s), not
    gstr->len

 scripts/kconfig/expr.h   |  2 +-
 scripts/kconfig/mconf.c  | 60 +++++++++++++++++++++++-------------------------
 scripts/kconfig/menu.c   | 11 +++++----
 scripts/kconfig/symbol.c |  2 +-
 scripts/kconfig/zconf.l  |  1 -
 5 files changed, 37 insertions(+), 39 deletions(-)

-- 
1.8.1.5


