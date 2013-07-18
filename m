Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422Ab3GRUrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:47:51 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36927 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129Ab3GRUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:47:50 -0400
Date: Thu, 18 Jul 2013 22:47:44 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v2] kconfig: switch to "long long" for sanity
Message-ID: <20130718204744.GC3417@free.fr>
References: <20130718183201.GA21183@www.outflux.net>
 <CAMuHMdX4dj3q53RsWTTmo-AOU1ee-xgp257CwacJnHfWn0BEAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdX4dj3q53RsWTTmo-AOU1ee-xgp257CwacJnHfWn0BEAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees, Geert, All,

On 2013-07-18 22:00 +0200, Geert Uytterhoeven spake thusly:
> On Thu, Jul 18, 2013 at 8:32 PM, Kees Cook <keescook@chromium.org> wrote:
> > Instead of using "long" for kconfig "hex" and "range" values, which may
> > change in size depending on the host architecture, use "long long". This
> > will allow values greater than INT_MAX on 32-bit hosts when cross
> > compiling.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Ok, thanks, I'll take in my tree.

Is it material for -rc-fixes, or can it wait in -for-next?

My gut feelings is that it does not fix an existing breakage, but only a
potential problem in the future, so it would be a candidate for
-for-next. Agreed?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
