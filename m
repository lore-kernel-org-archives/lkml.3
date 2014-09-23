Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaIWI1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:27:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55914 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIWI1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:27:35 -0400
Date: Tue, 23 Sep 2014 10:27:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chris@arachsys.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: kvm: use alternatives for VMCALL vs. VMMCALL if
 kernel text is read-only
Message-ID: <20140923082728.GC22072@pd.tnic>
References: <1411384668-11135-1-git-send-email-pbonzini@redhat.com>
 <20140922194335.GB5119@pd.tnic>
 <5421288C.9090805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5421288C.9090805@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:00:12AM +0200, Paolo Bonzini wrote:
> Il 22/09/2014 21:43, Borislav Petkov ha scritto:
> >> > On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.
> > Hmm, that depends on DEBUG_KERNEL.
> > 
> > I think you're actually talking about distro kernels which enable
> > CONFIG_DEBUG_RODATA, right?
> 
> This is for guest kernels, so it's not necessarily distro kernels.
> Anyone who compiles their kernel with CONFIG_DEBUG_RODATA + PV spinlocks
> would not be able to run it on AMD.

I see. Yeah, so the patch makes sense to me:

Acked-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
