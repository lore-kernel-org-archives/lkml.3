Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaISMUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:20:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33892 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaISMTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:19:49 -0400
Date: Fri, 19 Sep 2014 12:32:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140919103244.GA2027@nazgul.tnic>
References: <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <541AD8F3.5010700@redhat.com>
 <20140918132635.GB27008@nazgul.tnic>
 <541ADFEB.6030801@redhat.com>
 <20140919075814.GA30491@nazgul.tnic>
 <4C4860C1-50A7-44F0-80DC-BF199B3B0827@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C4860C1-50A7-44F0-80DC-BF199B3B0827@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:59:32AM +0300, Nadav Amit wrote:
> As for the concern that CPUID fields would be extended into non-zero
> reserved bits - can someone point me to a single case that occurred in
> the last 20 years during which CPUID existed?

Do you have a guarantee that this won't happen in the future and break
all your fancy bitfields assumptions?

-- 
Regards/Gruss,
    Boris.
--
