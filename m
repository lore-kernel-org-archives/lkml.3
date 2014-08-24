Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaHXW66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 18:58:58 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:50389 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaHXW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 18:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140824184035.GA13254@localhost>
References: <20140824184035.GA13254@localhost>
Date: Sun, 24 Aug 2014 15:58:56 -0700
X-Google-Sender-Auth: Vpk81PuLNV7nSDtUD-nlHqpakcM
Message-ID: <CA+55aFzW676RhCgu8Wp2SMcnKT2q82_DB9Aof74fwZPuXNtjZw@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.17-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: kgene.kim@gmail.com, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 11:40 AM, Olof Johansson <olof@lixom.net> wrote:
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

Grr. Yes and no.

You didn't really mean for me to pull that branch, you meant for me to
pull your tag "fixes-for-linus".

Where did this fail? Do you still run an old broken git version that
guesses at what the pull target is, and makes sh*t up? Please update
if so.

And if not, how did the tag contents get added to the pull request
despite the pull request not mentioning the tag?

           Linus
