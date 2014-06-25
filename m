Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaFYHxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:53:53 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:44251 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaFYHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <53A91449.6010701@roeck-us.net>
References: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
	<1403584501.4587.153.camel@pasglop>
	<53A90718.4050401@roeck-us.net>
	<1403588053.4587.160.camel@pasglop>
	<53A91449.6010701@roeck-us.net>
Date: Wed, 25 Jun 2014 09:53:43 +0200
X-Google-Sender-Auth: IBfA3YDkiuLS-MGafVZnxQvMk2s
Message-ID: <CAMuHMdUW0aZ__ykR6CC793EM1RSEbYqbWaXtEqKjG4janF-rRQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 8:01 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> Sigh. Much easier to break something than to fix it. That would mean to get
> approval
> from at least three maintainers, and all that to get rid of a warning. I
> don't
> really have time for that. Let's just forget about it and live with the
> warning.

So you send it to akpm. Or perhaps even trivial.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
