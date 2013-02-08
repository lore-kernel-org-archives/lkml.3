Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947305Ab3BHXHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:07:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35374 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947176Ab3BHXHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:07:03 -0500
Date: Sat, 9 Feb 2013 00:06:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Message-ID: <20130208230655.GB28990@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
References: <20130208191213.GA25081@www.outflux.net>
 <00780235-deac-4f80-b936-867834e05661@email.android.com>
 <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
 <5115553A.5000708@zytor.com>
 <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
 <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
 <1360355671.18083.18.camel@x230.lan>
 <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
 <51157C9C.6030501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51157C9C.6030501@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 02:30:52PM -0800, H. Peter Anvin wrote:
> Also, keep in mind that there is a very simple way to deny MSR access
> completely, which is to not include the driver in your kernel (and not
> allow module loading, but if you can load modules you can just load a
> module to muck with whatever MSR you want.)

I was contemplating that too. What is the use case of having
msr.ko in a secure boot environment? Isn't that an all-no-tools,
you-can't-do-sh*t-except-what-you're-explicitly-allowed-to environment which
simply doesn't need to write MSRs in the first place?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
