Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbbANSfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:35:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36382 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbbANSft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:35:49 -0500
Date: Wed, 14 Jan 2015 19:35:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Message-ID: <20150114183546.GC6902@pd.tnic>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:27:47AM -0800, Andy Lutomirski wrote:
> How are you manually triggering an MCE?  I've been playing with some
> MCE stuff recently, but the only reasonably reliable way I know of to
> trigger an MCE is using WHEA, and I don't have a box with WHEA, and I
> assume your ASUS T100 doesn't either.

asm volatile("int $18");

> Tianocore makes assumptions about the kernel's GDT layout?  Yuck.

Yuck indeed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
