Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbaDHWo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:44:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47187 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaDHWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:44:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140408204906.GA3616@cloud>
References: <20140407201919.GA15838@sepie.suse.cz>
	<CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
	<20140408204906.GA3616@cloud>
Date: Tue, 8 Apr 2014 15:44:25 -0700
X-Google-Sender-Auth: ohU8ng_HM-3FjTJJ0rAOPMUB9ao
Message-ID: <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <ak@linux.intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 1:49 PM,  <josh@joshtriplett.org> wrote:
>
> In addition to making the kernel smaller and such (I'll leave the
> specific stats there to Andi), here's the key awesomeness of LTO that
> you, personally, should find useful and compelling: LTO will eliminate
> the need to add many lower-level Kconfig symbols to compile out bits of
> the kernel.

Actually that, to me, is a negative right now.

Since there's no way we'll make LTO the default in the foreseeable
future, people starting to use it like that is just a bad bad thing.

So really, the main advantage of LTO would be any actual optimizations
it can do. And call me anal, but I want *numbers* for that before I
merge it. Not handwaving. I'm not actually aware of how well - if at
all - code generation actually improves.

                Linus
