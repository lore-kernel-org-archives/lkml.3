Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaLJLdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:33:53 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52849 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLJLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:33:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 9/9] ARM64: SoC changes for 3.19
Date: Wed, 10 Dec 2014 12:33:16 +0100
Message-ID: <142437558.Xy2szB89Mt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+55aFwU2qa+4BssUg3zCmZVPz5fmAHLgy--2=yb-NjXMZNDhg@mail.gmail.com>
References: <4491193.a6KEQb1tZH@wuerfel> <2482441.CQUhI8rqR1@wuerfel> <CA+55aFwU2qa+4BssUg3zCmZVPz5fmAHLgy--2=yb-NjXMZNDhg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:mcUfaT6SX5GjHHaxk3SfX2aQ/2tfi4wuV73IDSt3TCdLnFeZxy0
 KkayHOzuci1dZ8uWkqe8SxOHiFQqFrUEk99lXMuhx/Bp4VHMGZQeHAmOHif0r/ghgKt384v
 VQYuGXB5ADyhCrZ/jkB9KAKKN+YEG4gCKy/T4Rrp2rzvX+BeuHz707i9X+yADM/iEwtgKvl
 BlNireEXbsRtCDpord9hQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 17:20:43 Linus Torvalds wrote:
> On Tue, Dec 9, 2014 at 1:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/arm64-for-linus
> 
> I get the same shortlog this time, but a different diffstat again.
> 
> Oh well. At least this time my diffstat is smaller.
> 

Ah, my mistake. This branch included the move of the files that was done in the
cleanup branch. In the other pull requests I manually did the diffstat to match
what I expect you would see instead of what "git request-pull" tells me, while
for this one, the diffstat looked correct to me and I did not recreate one
manually.

	Arnd
