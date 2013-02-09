Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3BIJ3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 04:29:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36063 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3BIJ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 04:29:33 -0500
Date: Sat, 9 Feb 2013 10:29:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Message-ID: <20130209092925.GA17728@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
 <1360355671.18083.18.camel@x230.lan>
 <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
 <51157C9C.6030501@zytor.com>
 <20130208230655.GB28990@pd.tnic>
 <1360366012.18083.21.camel@x230.lan>
 <5115A4CC.3080102@zytor.com>
 <1360373383.18083.23.camel@x230.lan>
 <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 10:45:35PM -0800, Kees Cook wrote:
> Also, _reading_ MSRs from userspace arguably has utility that doesn't
> compromise ring-0.

And to come back to the original question: what is that utility, who
would need it on a secure boot system and why?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
