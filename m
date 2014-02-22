Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaBVIsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:48:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaBVIsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:48:33 -0500
Date: Sat, 22 Feb 2014 09:50:31 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140222085030.GA26794@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
 <5304B09D.7010900@redhat.com>
 <20140221170414.GM17353@dhcp-26-207.brq.redhat.com>
 <20140221170504.GN17353@dhcp-26-207.brq.redhat.com>
 <530788C1.6030109@redhat.com>
 <20140221185620.GA18725@dhcp-26-207.brq.redhat.com>
 <5307C6D9.4030503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307C6D9.4030503@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:36:25PM +0100, Paolo Bonzini wrote:
> Il 21/02/2014 19:56, Alexander Gordeev ha scritto:
> >On Fri, Feb 21, 2014 at 06:11:29PM +0100, Paolo Bonzini wrote:
> >>It's okay, but it's not clear to me whether I should include this
> >>patch or someone else will. :)
> >
> >Please, include it.
> 
> And where do I get pci_enable_msix_exact?  When will pci_enable_msix
> disappear?

Commit d158fc7 ("Merge tag 'pci-v3.14-fixes-1'") in Linus's tree has it.

pci_enable_msix() is going to be removed once all drivers updated with
new interface.

> So, do I have to pull something (which I'd rather not, since pulling
> the wrong thing in a submaintainer tree will make Linus angry), or
> should I do it in the next merge window after pci_enable_msix_exact
> gets in?

So it is already in.

> All in all, it seems much simpler to me if the linux-pci tree just
> includes the whole patch series with my Acked-by.
>
> Paolo
> 
> >Thanks!
> >
> >>Paolo
> >
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
