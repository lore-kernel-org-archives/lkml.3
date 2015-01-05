Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbbAELfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:35:33 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58471 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbAELfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:35:06 -0500
MIME-Version: 1.0
In-Reply-To: <1420456786-5989-1-git-send-email-drysdale@google.com>
References: <1420456786-5989-1-git-send-email-drysdale@google.com>
Date: Mon, 5 Jan 2015 12:35:04 +0100
X-Google-Sender-Auth: PGIm1cGsPJkPjw7NcOTMZazaL0Y
Message-ID: <CAMuHMdWFoSKB9F969_jUhwHQdPiid8QcjeYOSoE8cS9wHewH7A@mail.gmail.com>
Subject: Re: [PATCH] selftests/exec: allow shell return code of 126
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Drysdale <drysdale@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 12:19 PM, David Drysdale <drysdale@google.com> wrote:
> When the shell fails to invoke a script because its path name
> is too long (ENAMETOOLONG), most shells return 127 to indicate
> command not found.  However, some systems report 126 (which POSIX
> suggests should indicate a non-executable file) for this case,
> so allow that too.

Thanks, after this patch, the execveat selftest succeeds on m68k with
Debian 4.0.

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David Drysdale <drysdale@google.com>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
