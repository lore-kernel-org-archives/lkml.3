Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3J2Lg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:36:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab3J2LgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:36:25 -0400
Date: Tue, 29 Oct 2013 13:36:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] kvm: Emulate MOVBE, v3
Message-ID: <20131029113603.GC15657@redhat.com>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <20131029095300.GW15657@redhat.com>
 <20131029103003.GA10977@pd.tnic>
 <20131029103524.GZ15657@redhat.com>
 <20131029112824.GD10972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029112824.GD10972@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:28:24PM +0100, Borislav Petkov wrote:
> On Tue, Oct 29, 2013 at 12:35:24PM +0200, Gleb Natapov wrote:
> > If everything still applies patch 4 resend should be fine.
> 
> Which tree should they still apply to?
> 
git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue branch.

> > Yeah, kvm forum was not at the same building as LinuxCon :(
> 
> Yep, I know. We did go to the kvm forum to use the wifi there because
> the wifi at the conf was awful, as it is always the case at such
> high-count events :)
> 
That's why we got "max users limit is reached" error! (only for the
first half a day though) :)

--
			Gleb.
