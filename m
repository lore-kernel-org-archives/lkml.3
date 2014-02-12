Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaBLSGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:06:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbaBLSGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:06:07 -0500
Date: Wed, 12 Feb 2014 19:08:04 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/34] bnx2: Use pci_enable_msix_range()
Message-ID: <20140212180803.GA7948@dhcp-26-207.brq.redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
 <434a34e01c353441131204edef36126a95e8928a.1391172839.git.agordeev@redhat.com>
 <20140131.133051.483295479425700960.davem@davemloft.net>
 <20140211003814.GC12851@google.com>
 <20140211010803.GD12851@google.com>
 <20140212132640.GA3147@dhcp-26-207.brq.redhat.com>
 <CAErSpo7Puj1hgpmnjvuBjvoNjHQUyOU-axsKm+PY3j8jkZHDAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7Puj1hgpmnjvuBjvoNjHQUyOU-axsKm+PY3j8jkZHDAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:00:28AM -0700, Bjorn Helgaas wrote:
> > Do you want pci_enable_msi_exact() in addition to pci_enable_msix_exact()?
> 
> If there are cases where pci_enable_msi_exact() would be used, I guess
> the same arguments would apply, so yes.  I haven't looked at the

Just a handful of cases in the tree where it could be used for MSI right now,
but still - they do exist.

> archives, but I have this nagging feeling that this is exactly what
> you proposed initially, and I had some objection.  If so, I'm sorry
> about changing my mind :)

You are on PCI guard, no worries ;)

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
