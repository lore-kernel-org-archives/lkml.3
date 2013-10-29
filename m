Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3J2Kfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3J2Kfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:35:44 -0400
Date: Tue, 29 Oct 2013 12:35:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] kvm: Emulate MOVBE, v3
Message-ID: <20131029103524.GZ15657@redhat.com>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <20131029095300.GW15657@redhat.com>
 <20131029103003.GA10977@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029103003.GA10977@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:30:03AM +0100, Borislav Petkov wrote:
> On Tue, Oct 29, 2013 at 11:53:00AM +0200, Gleb Natapov wrote:
> > Except a small nitpick for patch 4 this looks good to me. No need to
> > wait for QEMU cpu parsing code to change to apply it.
> 
> Ok, want a resend or rather a pull request or only patch 4 resend?
> 
If everything still applies patch 4 resend should be fine.

> Btw, we kinda missed each other in Edinburgh to exchange fingerprints
> for pull request :-\
> 
Yeah, kvm forum was not at the same building as LinuxCon :(

--
			Gleb.
