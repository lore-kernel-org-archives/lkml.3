Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaLHKcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:32:22 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:56232 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaLHKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:32:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141208212523.47c3cf35@canb.auug.org.au>
References: <1418032337-15218-1-git-send-email-geert@linux-m68k.org>
	<20141208212523.47c3cf35@canb.auug.org.au>
Date: Mon, 8 Dec 2014 11:32:18 +0100
X-Google-Sender-Auth: gaYxdzVc9ig-_XPZFoJNOzkXwJ0
Message-ID: <CAMuHMdWSUP=iRsMZD2ZphdGnZy_d6+wKByVZ+RbrpUmvMvjsdA@mail.gmail.com>
Subject: Re: [git pull] m68k updates for 3.19
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Dec 8, 2014 at 11:25 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Mon,  8 Dec 2014 10:52:17 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:
>>
>>   Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
>>
>> for you to fetch changes up to f0b99a643e9613beb28af43333bbfa90d4bf85cc:
>>
>>   m68k/mm: Eliminate memset after alloc_bootmem_pages (2014-11-10 09:56:44 +0100)
>
> It looks like this branch has not updated yet (or you forgot to push).
> It is still commit f7bbd12a4b7e088f53f20dd31019984459699fb9 on
> git.kernel.org.

Woops, fixed. Sorry for that.

Actually git tried to tell me, by showing "for-next" instead of "for-linus"
in the output from request-pull, but I choose to ignore that as they're
both pointing to the same commit, and fix that manually. Oh well...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
