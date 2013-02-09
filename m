Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3BIGpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 01:45:39 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47961 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3BIGph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 01:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <1360373383.18083.23.camel@x230.lan>
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
	<20130208230655.GB28990@pd.tnic>
	<1360366012.18083.21.camel@x230.lan>
	<5115A4CC.3080102@zytor.com>
	<1360373383.18083.23.camel@x230.lan>
Date: Fri, 8 Feb 2013 22:45:35 -0800
X-Google-Sender-Auth: fPbqVtMplClgy9_EsQYJm7rGvjo
Message-ID: <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 5:29 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2013-02-08 at 17:22 -0800, H. Peter Anvin wrote:
>
>> You don't have to build the kernel twice to exclude a loadable module.
>
> I guess you could just strip the signatures off any modules you don't
> want to support under Secure Boot, but that breaks some other use cases.

Also, _reading_ MSRs from userspace arguably has utility that doesn't
compromise ring-0. So excluding the driver entirely seems like
overkill.

-Kees

--
Kees Cook
Chrome OS Security
