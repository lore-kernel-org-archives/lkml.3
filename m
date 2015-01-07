Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbbAGPzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:55:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbbAGPzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:55:06 -0500
Date: Wed, 7 Jan 2015 16:55:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] x86_64,entry: Fix RCX for traced syscalls
Message-ID: <20150107155500.GE3984@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net>
 <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
 <20150105125943.GC19655@pd.tnic>
 <CALCETrVEnVV5gibE++gj=eudqEBFTckDasqcY2zZDC9Y+NMUrQ@mail.gmail.com>
 <20150106153429.GB32560@pd.tnic>
 <CALCETrXGmDOo-4aT3Zh2UzCHNK_Rkyw=y0sKMVBo=7Vjb9O1BA@mail.gmail.com>
 <20150106190041.GG32560@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150106190041.GG32560@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 08:00:41PM +0100, Borislav Petkov wrote:
> I'll redo the whole games tomorrow.

Ok I can't reproduce today either. Let's ascribe it to this particular
test box being funny or something in 3.19-rcs.

We can look at it if it happens again.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
