Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaJIKef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:34:35 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43286 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaJIKe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <20141009064813.GA20517@gmail.com>
References: <20141009064813.GA20517@gmail.com>
Date: Thu, 9 Oct 2014 06:34:26 -0400
X-Google-Sender-Auth: CiZ7ONZewUFBDY-DUBPSNfBrDh4
Message-ID: <CA+55aFy5RDVOy79J-XkKVgpZhh8ph42pPeSFtFmWjFhyx-G8Yw@mail.gmail.com>
Subject: Re: [GIT PULL] timers/nohz updates for v3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm..

On Thu, Oct 9, 2014 at 2:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest timers-nohz-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus
>
>    # HEAD: 9b01f5bf3999a3db5b1bbd9fdfd80d8d304e94ee nohz: nohz full depends on irq work self IPI support
>
> Main changes:
>
>  - Fix the deadlock reported by Dave Jones et al
>  - Clean up and fix nohz_full interaction with arch abilities
>  - nohz init code consolidation/cleanup

Ok, pulled. But none of these are marked for stable, yet the deadlock
people are seeing is in 3.17. Is there a separate line of minimal
fixes just for that? Or was the lack of stable tags just an oversight?

                 Linus
