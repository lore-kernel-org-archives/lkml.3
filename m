Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966121Ab3DQSLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:11:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:57825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924Ab3DQSLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:11:05 -0400
Message-ID: <516EE5AB.4080201@infradead.org>
Date: Wed, 17 Apr 2013 11:10:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 17 (kvm)
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au>
In-Reply-To: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/13 00:04, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130416:
> 


on i386, SMP is disabled, X86_UP_APIC is not enabled, but
CONFIG_KVM_APIC_ARCHITECTURE=y:

arch/x86/kvm/vmx.c: In function 'vmx_deliver_posted_interrupt':
arch/x86/kvm/vmx.c:3950:3: error: 'apic' undeclared (first use in this function)


-- 
~Randy
