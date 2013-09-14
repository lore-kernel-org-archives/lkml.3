Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab3INXbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 19:31:46 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50693 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3INXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 19:31:44 -0400
Date: Sun, 15 Sep 2013 01:31:39 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Clement Chauplannaz <chauplac@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: scripts/config: fix variable substitution command
Message-ID: <20130914233139.GC3444@free.fr>
References: <CA+icZUUkJgeUaJmNzAZQysV9dUHzwPzU7k3pn8vrThSD780xaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUUkJgeUaJmNzAZQysV9dUHzwPzU7k3pn8vrThSD780xaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On 2013-09-14 14:21 +0200, Sedat Dilek spake thusly:
> The ChangeLog from [1] says:
> 
> Commit 229455bc02b87f7128f190c4491b4ceffff38648 accidentally changed
> the separator between sed `s' command and its parameters from ':' to
> '/'.
> Revert this change.
[--SNIP--]
> Is this patch even "CC: stable"?

It was not in any previous released version, since it went in Linus'
tree for 3.12. As such, it does not make sense to Cc: stable.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
