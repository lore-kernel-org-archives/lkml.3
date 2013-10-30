Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3J3Sod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:44:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44876 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3J3Soa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:44:30 -0400
Date: Wed, 30 Oct 2013 19:44:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] kvm: Emulate MOVBE, v3
Message-ID: <20131030184423.GG13290@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <52714BB0.8010504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52714BB0.8010504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:10:56PM +0100, Paolo Bonzini wrote:
> I tested this patch manually with a small C test program and asm.
> 
> Would you please prepare a patch to kvm-unit-tests that stresses the new
> codepath?

Ha, now that you bring that up, I think Andre already had something
ready. Andre?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
