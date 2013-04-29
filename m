Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3D2RC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:02:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab3D2RCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:02:55 -0400
Message-ID: <1367254910.16887.101.camel@ul30vt.home>
Subject: Re: linux-next: Tree for Apr 29 (kvm)
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>
Date: Mon, 29 Apr 2013 11:01:50 -0600
In-Reply-To: <517EA3DA.3070706@redhat.com>
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
	 <517E9758.4000506@infradead.org> <20130429163135.GA2737@redhat.com>
	 <517EA3DA.3070706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 18:46 +0200, Paolo Bonzini wrote:
> Il 29/04/2013 18:31, Gleb Natapov ha scritto:
> >> > arch/x86/kvm/x86.c: In function 'kvm_dev_ioctl_check_extension':
> >> > arch/x86/kvm/x86.c:2547:22: error: 'pci_bus_type' undeclared (first use in this function)
> >> > 
> >> > 
> >> > Oops, CONFIG_PCI is not enabled.
> > Alex, can you look at this please. Before "kvm: Allow build-time configuration
> > of KVM device assignment" commit KVM depended on PCI to be enabled.
> > 
> 
> KVM_CAP_IOMMU probably should depend on device assignment.  It doesn't
> really belong in KVM at all, and is only there for device assignment.

Yep, exactly.

