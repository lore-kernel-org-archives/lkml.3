Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3JHVcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:32:21 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:50527 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3JHVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:32:18 -0400
Date: Tue, 8 Oct 2013 23:32:11 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>, Benjamin Poirier <bpoirier@suse.de>,
        Dirk Gouders <dirk@gouders.net>, Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] kconfig: cleanups, documentation updates, and one
 bug fix
Message-ID: <20131008213211.GB3373@free.fr>
References: <3926659.JuuXvBGSjN@tacticalops>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3926659.JuuXvBGSjN@tacticalops>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin, All,

On 2013-10-03 19:24 +0200, Martin Walch spake thusly:
> In this second attempt, I tried to incorporate all replies I received for the
> first version of this patch set:

Since there have been positive reviews for thie patches in this series,
I'll take it in my tree.

Regards,
Yann E. MORIN.

> PATCH 1: kconfig: add short explanation to SYMBOL_WRITE
>  Ignore this one as long as there is no clear conclusion about the purpose
>  of SYMBOL_WRITE. I only include it, so the patch numbers do not change and
>  there is no "hole" in the patch set.
> 
> PATCH 2: kconfig: fix trivial typos and update mconf documentation
>  In the first place, this corrected only three typos. Now this patch corrects
>  all bad occurrences of "tell" instead of "tells" and fixes several more
>  spelling mistakes. Furthermore some changes that have been made to mconf
>  during the last years are now also updated in the documentation.
> 
> PATCH 3: kconfig: adjust warning message for conflicting types
>  Now explicitely state that the second type is being ignored.
> 
> PATCH 4: kconfig: remove unused definition from scanner
>  No changes since the first version.
> 
> PATCH 5: kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len
>  As I do not think it is worth to make this a separate patch, I appended
>  this fix for a bug that is only triggered by the search function of mconf.
> 
> Martin Walch (5):
>   kconfig: add short explanation to SYMBOL_WRITE
>   kconfig: fix trivial typos and update mconf documentation
>   kconfig: adjust warning message for conflicting types
>   kconfig: remove unused definition from scanner
>   kconfig: fix bug in search results string: use strlen(gstr->s), not
>     gstr->len
> 
>  scripts/kconfig/expr.h   |  2 +-
>  scripts/kconfig/mconf.c  | 60 +++++++++++++++++++++++-------------------------
>  scripts/kconfig/menu.c   | 11 +++++----
>  scripts/kconfig/symbol.c |  2 +-
>  scripts/kconfig/zconf.l  |  1 -
>  5 files changed, 37 insertions(+), 39 deletions(-)
> 
> -- 
> 1.8.1.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
