Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaLJIVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:21:12 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53476 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaLJIVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <1416835236-25185-1-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
Date: Wed, 10 Dec 2014 09:21:10 +0100
Message-ID: <CAFLxGvwpyapTJKDrgtfy=qMW7u9hjXB9zRq+EkgE3zCummc7rw@mail.gmail.com>
Subject: Re: Fastmap update v2 (pile 1)
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 2:20 PM, Richard Weinberger <richard@nod.at> wrote:
> Artem,
>
> as requested I'm resending my fastmap work in smaller pieces.
> This is pile 1 of 7.
> Rebasing my patches to ubifs.git was a massive PITA because the
> logging style changes touched a lot of code and almost every patch
> failed to apply and needed inspection by hand.
> The first patches are bug fixes, the latter introduce cleanups
> and new features.
> After all bugfixes are mainline I'll make sure that all needed
> fixes go into -stable.

Artem,

how shall we proceed?
Currently around 45 of my patches are in flight.
Some got comments, some not. If it helps I can address these comments
immediately
and resend the individual patches. The vast majority of all comments
are trivial to fix (typos, style, etc..)
Initially I hoped that all patches will get comments such that I can
do a v3 which can be merged
in 3.19-rc1. :-\

In my local queue even more patches wait to be submitted.

-- 
Thanks,
//richard
