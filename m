Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3ANV3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:29:06 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63337 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3ANV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:29:04 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 14 Jan 2013 22:29:03 +0100
Message-ID: <CA+icZUXyTvW0P4Adbr2x+RP3X-b3Qj8E53uxWrnDe964MgZepg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix BUG on madvise early failure
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>, Shaohua Li <shli@fusionio.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch is for Linux-Next - more exactly next-20130114.
Can you please enhance the subject-line of your patch next time.

Your patch fixes the issue I have reported a few hours ago in [1].

[ TESTCASE ]

"madvise02" from Linux Test Project (LTP) see [2]

$ cd /opt/ltp/testcases/bin/

$ sudo ./madvise02
[ OUTPUT ]
madvise02    1  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22):
Invalid argument
madvise02    2  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22):
Invalid argument
madvise02    3  TPASS  :  failed as expected: TEST_ERRNO=EINVAL(22):
Invalid argument
madvise02    4  TPASS  :  failed as expected: TEST_ERRNO=ENOMEM(12):
Cannot allocate memory
madvise02    5  TFAIL  :  madvise succeeded unexpectedly

[ /TESTCASE ]

Please feel free and add a...

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks!

Regards,
- Sedat -

[1] http://marc.info/?l=linux-mm&m=135818843710244&w=2
[2] http://sourceforge.net/projects/ltp/
