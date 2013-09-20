Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3ITExq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:53:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56690 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3ITExl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <1379650985.2021.12.camel@joe-AO722>
References: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
	<20130917205742.16147.qmail@science.horizon.com>
	<201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
	<CAGXu5jK_D1BJOQr=1A-UFrpM5Ad+Qu894HT_XjkZh4EmsbCkTQ@mail.gmail.com>
	<201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
	<1379650985.2021.12.camel@joe-AO722>
Date: Thu, 19 Sep 2013 21:53:40 -0700
X-Google-Sender-Auth: cK0D2B5Sv-auAs4dMDx-E3_2Ow0
Message-ID: <CAGXu5jJNuFbBrYyWufqhDOapS4qYWkvLMi4pk8AnqgD8wXo5RA@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jiri Slaby <jslaby@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@openvz.org>, remi.denis-courmont@nokia.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 9:23 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-09-20 at 13:09 +0900, Tetsuo Handa wrote:
>> Hello.
>
> Tetsuo-san:
>
>> We are discussing about removal of %n support from vsnprintf() at
>> https://lkml.org/lkml/2013/9/16/52 , and you are using %n in seq_printf().
>
> Well, I'm not using (mere alcohol isn't using, right?)
> but I still have the same question for Al.
>
> Are there any races here?

All the call sites I examined were linear. FWIW, I didn't see any races.

-Kees

>
>> I posted https://lkml.org/lkml/diff/2013/9/19/53/1 which introduces
>> seq_setwidth() / seq_pad() which can avoid use of %n in seq_printf().
>
> I still think adding last_len, last_rtn
> is sensible.
>
>



-- 
Kees Cook
Chrome OS Security
