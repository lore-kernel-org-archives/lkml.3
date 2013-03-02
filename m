Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3CBSkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:40:18 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:60587 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab3CBSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:40:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130302181025.GA15498@pd.tnic>
References: <5130DD94.2060408@imgtec.com>
	<CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
	<5130F978.9040604@imgtec.com>
	<5131D2F0.2010705@imgtec.com>
	<CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
	<20130302181025.GA15498@pd.tnic>
Date: Sat, 2 Mar 2013 10:40:16 -0800
X-Google-Sender-Auth: dKZlsBBD_P_2GDvr1LqIgoS1er4
Message-ID: <CA+55aFyTg5oxT-Sx65CF3RJaK8Ejyf7RvPSrTWv-bNV0Um-k+w@mail.gmail.com>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>, James Hogan <james.hogan@imgtec.com>,
        Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 10:10 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> Hmm, so this comes up almost everytime new maintainers send stuff (and
> when seasoned maintainers forget :)), maybe we should hold it down
> somewhere in Documentation/ for future reference?

If somebody wants to edit it a bit for readability (and maybe try to
gather previous rants of mine), I'll happily take the patch.

And we should probably add some commentary from submaintainers too.
They often have their own issues. Some of them are the same "dammit, I
relied on a rebased tree of another", but I bet there are cross-merge
issues *within* submaintainerships too (eg there are some trees that I
pull that have their internal topic branches with multiple maintainers
where they merge between them, and some of them sometimes seem to have
a bit too much merging going on).

                Linus
