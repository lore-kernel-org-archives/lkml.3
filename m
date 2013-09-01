Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3IAIws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 04:52:48 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33769 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3IAIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 04:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <1376928619-3775-8-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	<1376928619-3775-8-git-send-email-matthew.garrett@nebula.com>
Date: Sun, 1 Sep 2013 10:52:45 +0200
X-Google-Sender-Auth: WmOJUbeKLnTJxRQTfSf8YsP1dPE
Message-ID: <CAMuHMdVPAEQn8wmNnagPpy45OSSzvjX-LUDx8G8eWiOFh=4sSw@mail.gmail.com>
Subject: Re: [PATCH 08/10] kexec: Disable at runtime if the kernel enforces
 module loading restrictions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 6:10 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.

Any plans for signed kexec code?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
