Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3CBTGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:06:52 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33446 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3CBTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130302181025.GA15498@pd.tnic>
References: <5130DD94.2060408@imgtec.com> <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
 <5130F978.9040604@imgtec.com> <5131D2F0.2010705@imgtec.com>
 <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com> <20130302181025.GA15498@pd.tnic>
From: Raymond Jennings <shentino@gmail.com>
Date: Sat, 2 Mar 2013 11:06:10 -0800
Message-ID: <CAGDaZ_pLi3EkeDbfYyh9JXCuWnbyRZdh2OMn6ipzDbM9ETWthg@mail.gmail.com>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>, Arnd <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 10:10 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Mar 02, 2013 at 08:28:56AM -0800, Linus Torvalds wrote:
>> On Sat, Mar 2, 2013 at 2:22 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> >
>> > Okay, I've rebased the arch/metag tree onto mainline to make all the
>> > back-merges unnecessary and applied those simple fixes into "Build
>> > infrastructure" and "Various other headers" commits (additionally
>> > trivially removing ARCH_NO_VIRT_TO_BUS which is also now unnecessary).
>>
>> No, this is *exactly* the wrong thing to do.
>
> <snip good practices and musings about maintainer trees>
>
> Hmm, so this comes up almost everytime new maintainers send stuff (and
> when seasoned maintainers forget :)), maybe we should hold it down
> somewhere in Documentation/ for future reference?

Hear hear!

Come to think of it given how often Linus has bitched about rebasing
and back merging I'm surprised it's not already mentioned.

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
