Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3J3SDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:03:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36356 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3J3SDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:03:21 -0400
Date: Wed, 30 Oct 2013 19:03:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH 5/5 -v3.1] kvm: Emulate MOVBE
Message-ID: <20131030180313.GA23167@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <20131029095300.GW15657@redhat.com>
 <20131029103003.GA10977@pd.tnic>
 <20131029103524.GZ15657@redhat.com>
 <20131029112824.GD10972@pd.tnic>
 <20131029113603.GC15657@redhat.com>
 <20131029115303.GE10972@pd.tnic>
 <20131029115456.GG10972@pd.tnic>
 <5271483A.10805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5271483A.10805@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 06:56:10PM +0100, Paolo Bonzini wrote:
> Thanks, I've applied these patches to kvm/queue.

Cool.

As I'm sure I'll miss the qemu development, please ping me when the qemu
side is ready for adding the KVM_GET_EMULATED_CPUID thing there.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
