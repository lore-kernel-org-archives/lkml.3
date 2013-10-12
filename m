Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3JLTle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:41:34 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51048 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3JLTld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <820c2fd2311341ce8a9b59e621c3fd1f@BY2PR05MB222.namprd05.prod.outlook.com>
References: <20131012171553.GA17548@gmail.com>
	<CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
	<820c2fd2311341ce8a9b59e621c3fd1f@BY2PR05MB222.namprd05.prod.outlook.com>
Date: Sat, 12 Oct 2013 12:41:32 -0700
X-Google-Sender-Auth: ANi_DkAnG8ewTeFeza4yJsJwBqA
Message-ID: <CA+55aFz2b_HYRuATpquNEo1yD=iWLJmCQAJ2pxYcsePjpY+CiQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 12:28 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
>
> The most likely cause of the problem that we're seeing here is that we're leaving the hardware in a state that isn't compatible with assumptions made by Dell's SMM code. We've certainly seen that some previous Dell machines have made incorrect assumptions about VT-d, which probably means that we should be destroying that state before reboot. David Woodhouse had been looking into that - I don't know whether we ever actually merged anything to do so.

I have access to one of the affected Dell systems, so I'm willing to
try patches..

            Linus
