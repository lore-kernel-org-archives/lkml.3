Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaIVTno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:43:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49937 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbaIVTnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:43:41 -0400
Date: Mon, 22 Sep 2014 21:43:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chris@arachsys.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: kvm: use alternatives for VMCALL vs. VMMCALL if
 kernel text is read-only
Message-ID: <20140922194335.GB5119@pd.tnic>
References: <1411384668-11135-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411384668-11135-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:17:48PM +0200, Paolo Bonzini wrote:
> On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.

Hmm, that depends on DEBUG_KERNEL.

I think you're actually talking about distro kernels which enable
CONFIG_DEBUG_RODATA, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
