Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3J2L2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:28:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55694 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3J2L2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:28:30 -0400
Date: Tue, 29 Oct 2013 12:28:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] kvm: Emulate MOVBE, v3
Message-ID: <20131029112824.GD10972@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <20131029095300.GW15657@redhat.com>
 <20131029103003.GA10977@pd.tnic>
 <20131029103524.GZ15657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131029103524.GZ15657@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:35:24PM +0200, Gleb Natapov wrote:
> If everything still applies patch 4 resend should be fine.

Which tree should they still apply to?

> Yeah, kvm forum was not at the same building as LinuxCon :(

Yep, I know. We did go to the kvm forum to use the wifi there because
the wifi at the conf was awful, as it is always the case at such
high-count events :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
