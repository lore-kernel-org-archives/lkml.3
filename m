Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaGPWlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:41:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54209 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaGPWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
References: <cover.1405546879.git.luto@amacapital.net> <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
 <53C6F5A9.80400@zytor.com> <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Jul 2014 15:40:55 -0700
Message-ID: <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 3:13 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> My personal preference is to defer this until some user shows up.  I
> think that even this would be too complicated for KASLR, which is the
> only extremely early-boot user that I found.
>
> Hmm.  Does the prandom stuff want to use this?

prandom isn't even using rdrand.  I'd suggest fixing this separately,
or even just waiting until someone goes and deletes prandom.

--Andy
