Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3IPToh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 15:44:37 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:44363 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3IPToe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 15:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0OEGSw+0a0skLCuSham2R+Q3UR=f=Ddf1-SeqS2qbE9zg@mail.gmail.com>
References: <1379049145-16017-1-git-send-email-realmz6@kernel.org>
	<CA+55aFzJtybx3B=zcv1atCD-wUMc1YLdXndjX_d_ZxTDUpmOrQ@mail.gmail.com>
	<CAJxxZ0OEGSw+0a0skLCuSham2R+Q3UR=f=Ddf1-SeqS2qbE9zg@mail.gmail.com>
Date: Mon, 16 Sep 2013 15:44:33 -0400
X-Google-Sender-Auth: 1a4m2CuLocxzzCpvXJ-yYLvsevs
Message-ID: <CA+55aFwkKBbvN5sE5SxLpjZhUPE252s-3ptwnJ=9t97j_XAiAw@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Steven Miao <realmz6@kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 1:28 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>
> I am sorry to put many config options into the Blackfin Kconfig file.
> In the case this is not preferred, we will make sure no more device
> config options are put into the Kconfig files.

It's not so much "no more device config options", it's more a matter of level.

If it's a couple of core options in the SoC, what the heck, use
Kconfig. Many of your board files are pretty small and have one or two
device config options in them. That's fine.

It's when it's thousands of lines of Kconfig file (and that isn't even
comments or anything like that), then that's a sign that you should
start seriously thinking about using some proper device configuration.
Device-tree is the one most architectures use, but heck, maybe it's
overkill for blackfin.

                    Linus
