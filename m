Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaDXVbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:31:53 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:46841 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaDXVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:31:51 -0400
X-Greylist: delayed 2786 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 17:31:51 EDT
Date: Thu, 24 Apr 2014 16:45:12 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Message-ID: <1917070890.8703765.1398372312996.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140421133848.GC25116@dhcp-26-169.brq.redhat.com>
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com> <20140221170504.GN17353@dhcp-26-207.brq.redhat.com> <530788C1.6030109@redhat.com> <20140221185620.GA18725@dhcp-26-207.brq.redhat.com> <5307C6D9.4030503@redhat.com> <20140222085030.GA26794@dhcp-26-207.brq.redhat.com> <530866A2.7080804@redhat.com> <20140421133848.GC25116@dhcp-26-169.brq.redhat.com>
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF28 (Linux)/8.0.6_GA_5922)
Thread-Topic: Use pci_enable_msix_exact() instead of pci_enable_msix()
Thread-Index: Z4CUuP/0Isg3VZ9Idl3+bBbZ/HzN7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>> So, do I have to pull something (which I'd rather not, since pulling
> > >>> the wrong thing in a submaintainer tree will make Linus angry), or
> > >>> should I do it in the next merge window after pci_enable_msix_exact
> > >>> gets in?
> > >So it is already in.
> > 
> > It is not, because maintainer branches are not rebased.  KVM
> > development is based on 3.14-rc1, and will not get that commit until
> > the first 3.15 pull request is sent to Linux.
> > 
> > No big deal, I'll include this patch in a second 3.15 pull request.
> 
> Hi Paolo,
> 
> I believe it is safe to pull it now?

Yup, vacation got in the way of doing this during the merge window but I
can safely send this for -rc next week.  It was on my todo list.

Paolo
