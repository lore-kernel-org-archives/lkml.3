Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3KOQLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:11:33 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55261 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3KOQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:11:27 -0500
MIME-Version: 1.0
In-Reply-To: <20131115151958.3802.1019@localhost.localdomain>
References: <20131115151958.3802.1019@localhost.localdomain>
Date: Fri, 15 Nov 2013 17:11:26 +0100
X-Google-Sender-Auth: pBkDXAge7wnB3gzC1KknLh3FZlo
Message-ID: <CAMuHMdXousEc1jFsZOxq5chbbWb-E+mBX5hWfh3f_wmnTHaMJg@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 4:19 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> Chris Mason (1) commits (+7/-2):
>     btrfs: fix empty_zero_page misusage

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus&id=46e0f66a0cf9e1fe25bfdcf4a60c08aface85998

FYI, you may want to loop over longs instead of bytes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
