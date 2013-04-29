Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab3D2QuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:50:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab3D2Qt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:49:59 -0400
Message-ID: <1367254194.16887.100.camel@ul30vt.home>
Subject: Re: linux-next: Tree for Apr 29 (kvm)
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>
Date: Mon, 29 Apr 2013 10:49:54 -0600
In-Reply-To: <20130429163135.GA2737@redhat.com>
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
	 <517E9758.4000506@infradead.org> <20130429163135.GA2737@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 19:31 +0300, Gleb Natapov wrote:
> On Mon, Apr 29, 2013 at 08:52:56AM -0700, Randy Dunlap wrote:
> > On 04/29/13 02:17, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20130426:
> > > 
> > 
> > 
> > on x86_64:
> > 
> > arch/x86/kvm/x86.c: In function 'kvm_dev_ioctl_check_extension':
> > arch/x86/kvm/x86.c:2547:22: error: 'pci_bus_type' undeclared (first use in this function)
> > 
> > 
> > Oops, CONFIG_PCI is not enabled.
> Alex, can you look at this please. Before "kvm: Allow build-time configuration
> of KVM device assignment" commit KVM depended on PCI to be enabled.

Yep, patch coming...

