Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3KASQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:16:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56746 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3KASQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:16:29 -0400
Message-ID: <5273EFFA.1030400@infradead.org>
Date: Fri, 01 Nov 2013 11:16:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: linux-next: Tree for Nov 1 (xen_swiotllb)
References: <20131101191138.442028fb1f243c7f9c7f0844@canb.auug.org.au>
In-Reply-To: <20131101191138.442028fb1f243c7f9c7f0844@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 01:11, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20131031:
> 
> The squashfs tree gained a build failure so I used the version from
> next-20131031.
> 
> The block tree gained conflicts against the f2fs, aio-direct and Linus'
> trees and a build failure and generated several warnings so I used the
> version from next-20131031.
> 
> The dt-rh tree gained a conflict against the powerpc tree.
> 
> The kvm-ppc tree gained a conflict against the powerpc tree.
> 
> The leds tree gained a conflict against the powerpc tree.
> 
> The tty tree lost its build failure.


on x86_64, when CONFIG_PCI is not enabled:

arch/x86/built-in.o: In function `pci_xen_swiotlb_init_late':
(.text+0x102cc): undefined reference to `pci_request_acs'
arch/x86/built-in.o: In function `pci_xen_swiotlb_init':
(.init.text+0x3f6c): undefined reference to `pci_request_acs'


-- 
~Randy
