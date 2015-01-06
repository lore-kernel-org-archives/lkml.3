Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbbAFTAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:00:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49993 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbbAFTAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:00:45 -0500
Date: Tue, 6 Jan 2015 20:00:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] x86_64,entry: Fix RCX for traced syscalls
Message-ID: <20150106190041.GG32560@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net>
 <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
 <20150105125943.GC19655@pd.tnic>
 <CALCETrVEnVV5gibE++gj=eudqEBFTckDasqcY2zZDC9Y+NMUrQ@mail.gmail.com>
 <20150106153429.GB32560@pd.tnic>
 <CALCETrXGmDOo-4aT3Zh2UzCHNK_Rkyw=y0sKMVBo=7Vjb9O1BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXGmDOo-4aT3Zh2UzCHNK_Rkyw=y0sKMVBo=7Vjb9O1BA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:43:57AM -0800, Andy Lutomirski wrote:
> Sure, but the code would be simpler if we shoved that value in the
> EFLAGS slot.

There probably is some reason for that but it's not like we can change
it :-)

> Hmm.  I added and pushed a test for fork, but that didn't turn
> anything up.  And I don't see any bugs in the code.
> 
> I booted 3.18 plus this patch with context tracking forced on on my
> laptop, and something seems to have gone wrong.

Well, I ran it on -rc2 + tip/master and it did trigger sporadically
yesterday but was unable to trigger something today.

I'll redo the whole games tomorrow.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
