Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbaGPOxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:53:33 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58454 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933842AbaGPOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:53:31 -0400
Date: Wed, 16 Jul 2014 17:53:22 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
Message-ID: <20140716145322.GX18167@minantech.com>
References: <cover.1405477965.git.luto@amacapital.net>
 <20140716064110.GV18167@minantech.com>
 <53C62563.6050106@redhat.com>
 <53C62B68.50702@redhat.com>
 <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com>
 <53C68CF3.5070208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C68CF3.5070208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:32:19PM +0200, Paolo Bonzini wrote:
> Il 16/07/2014 16:07, Andy Lutomirski ha scritto:
> >This patch has nothing whatsoever to do with how much I trust the CPU
> >vs the hypervisor.  It's for the enormous installed base of machines
> >without RDRAND.
> 
> Ok.  I think an MSR is fine, though I don't think it's useful for the guest
> to use it if it already has RDRAND and/or RDSEED.
> 
Agree. It is unfortunate that we add PV interfaces for a HW that will be extinct
in a couple of years though :(

--
			Gleb.
