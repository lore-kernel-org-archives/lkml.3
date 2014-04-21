Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaDUNdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:33:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaDUNdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:33:04 -0400
Date: Mon, 21 Apr 2014 14:38:48 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140421133848.GC25116@dhcp-26-169.brq.redhat.com>
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
 <5304B09D.7010900@redhat.com>
 <20140221170414.GM17353@dhcp-26-207.brq.redhat.com>
 <20140221170504.GN17353@dhcp-26-207.brq.redhat.com>
 <530788C1.6030109@redhat.com>
 <20140221185620.GA18725@dhcp-26-207.brq.redhat.com>
 <5307C6D9.4030503@redhat.com>
 <20140222085030.GA26794@dhcp-26-207.brq.redhat.com>
 <530866A2.7080804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530866A2.7080804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 09:58:10AM +0100, Paolo Bonzini wrote:
> Il 22/02/2014 09:50, Alexander Gordeev ha scritto:
> >Commit d158fc7 ("Merge tag 'pci-v3.14-fixes-1'") in Linus's tree has it.
> >
> >pci_enable_msix() is going to be removed once all drivers updated with
> >new interface.
> >
> >>> So, do I have to pull something (which I'd rather not, since pulling
> >>> the wrong thing in a submaintainer tree will make Linus angry), or
> >>> should I do it in the next merge window after pci_enable_msix_exact
> >>> gets in?
> >So it is already in.
> 
> It is not, because maintainer branches are not rebased.  KVM
> development is based on 3.14-rc1, and will not get that commit until
> the first 3.15 pull request is sent to Linux.
> 
> No big deal, I'll include this patch in a second 3.15 pull request.

Hi Paolo,

I believe it is safe to pull it now?

Thanks!

> Paolo
