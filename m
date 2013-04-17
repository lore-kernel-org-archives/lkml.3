Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967009Ab3DQWze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:55:34 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:38436 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966905Ab3DQWzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:55:32 -0400
Date: Wed, 17 Apr 2013 15:55:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 17 (kvm)
In-Reply-To: <516EE5AB.4080201@infradead.org>
Message-ID: <alpine.DEB.2.02.1304171555030.10112@chino.kir.corp.google.com>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au> <516EE5AB.4080201@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Randy Dunlap wrote:

> On 04/17/13 00:04, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130416:
> > 
> 
> 
> on i386, SMP is disabled, X86_UP_APIC is not enabled, but
> CONFIG_KVM_APIC_ARCHITECTURE=y:
> 
> arch/x86/kvm/vmx.c: In function 'vmx_deliver_posted_interrupt':
> arch/x86/kvm/vmx.c:3950:3: error: 'apic' undeclared (first use in this function)
> 

Confirmed this happens on x86_64 as well, it seems that CONFIG_SMP=n is 
the key.
