Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3CBQbG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 11:31:06 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:38384 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3CBQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 11:31:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
References: <5130DD94.2060408@imgtec.com>
	<CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
	<5130F978.9040604@imgtec.com>
	<5131D2F0.2010705@imgtec.com>
	<CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
Date: Sat, 2 Mar 2013 08:31:02 -0800
X-Google-Sender-Auth: B5YGM-LPfmmJymXCzMrStMBbTQE
Message-ID: <CA+55aFydomo3dZ3JchdBraQc_-mAO4ToWLAtZF_J4yCrpoNrRg@mail.gmail.com>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 8:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - I'm usually a day or two behind in my merge queue anyway, partly
> because I get tons of pull requests in a short while and I just want
> to get a feel for what's going on, and partly because I tend to do
> pulls in waves of "ok, I'm going filesystems now, then I'll look at
> drivers".

Btw, that was why I replied now. I just did the MIPS and ARC merges,
so I started looking at this one. And I'm not pulling it in the
current state where it's based on one of my "random kernels of the day
in the middle of the merge window"

              Linus
