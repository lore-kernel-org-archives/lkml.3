Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3J2JxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3J2JxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:53:15 -0400
Date: Tue, 29 Oct 2013 11:53:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] kvm: Emulate MOVBE, v3
Message-ID: <20131029095300.GW15657@redhat.com>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379861095-628-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 04:44:49PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Alriiight,
> 
> here's another version of the patchset, hopefully addressing all review
> feedback from last time. 6/6 is the respective qemu patch to handle
> emulated features query, etc.
> 
Except a small nitpick for patch 4 this looks good to me. No need to
wait for QEMU cpu parsing code to change to apply it.

--
			Gleb.
