Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab3EAXfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:35:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab3EAXfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:35:33 -0400
Date: Thu, 2 May 2013 01:35:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501233530.GG15623@pd.tnic>
References: <20130501203500.GC4466@pd.tnic>
 <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
 <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
 <20130501222850.GB15623@pd.tnic>
 <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
 <20130501230254.GC15623@pd.tnic>
 <alpine.DEB.2.02.1305011606461.8804@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011606461.8804@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 04:16:40PM -0700, David Rientjes wrote:
> So you're missing CONFIG_X86_LOCAL_APIC and/or CONFIG_X86_IO_APIC,
> as already stated. Those are strict requirements for your
> CONFIG_KVM_GUEST_COMMON_OPTIONS to build. I suggest depending on them,
> most configs already have them.
>
> You'll probably also want to depend on NET_CORE since it requires that
> as well.
>
> That would probably make your patch complete.

See, we could've saved ourselves all the bullshit if you had started
with the above.

I'll add those to the lineup:

select PCI
select NET_CORE
select X86_IO_APIC
select X86_LOCAL_APIC

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
