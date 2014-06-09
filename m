Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaFIKIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:08:54 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:64789 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaFIKIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140607225356.GA5696@amd.pavel.ucw.cz>
References: <20140607225356.GA5696@amd.pavel.ucw.cz>
Date: Mon, 9 Jun 2014 11:08:51 +0100
X-Google-Sender-Auth: fPbgBTcQea-zAHtnrhIL9ba7Klc
Message-ID: <CAMLZHHRsewk=YqWp_sKULSfqyejgUWcZMjFp-G388xqaQBbg-g@mail.gmail.com>
Subject: Re: Kernel for olpc-1.75
From: Daniel Drake <dsd@laptop.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, chris@printf.net,
        dsd@gentoo.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sat, Jun 7, 2014 at 11:53 PM, Pavel Machek <pavel@ucw.cz> wrote:
> I broke installation on olpc-1.75, and I guess its time for it to
> start running self-compiled kernel. (It still boots if I hold right
> game key, but I can no longer control backlight. It does not boot at
> all by default.)
>
> AFAICT, olpc.fth and zImage in the boot/ directory of USB disk should
> do the trick.
>
> Unfortunately, 3.0 based kernels no longer compile with current tools,
> so I tried this version (3.6 based).

Sorry but OLPC never progressed beyond shipping 3.0 on this hardware,
and low-level development only really happens in maintenance mode at
the moment.

We did almost get a newer version working, but it had some unresolved
issues that prevented us from shipping it to users. I'm not sure of
the state of that arm-3.6 branch you are trying but I don't see
anything wrong in your process. I would try early printascii() calls
and a serial cable next.

Mainline won't run on the machine in any kind of usable state without
quite a bit of work on drivers and DT (which comes from the firmware).
I did once start on that but didn't manage to get even the initial
easy patches past the Marvell maintainers :(

Daniel
