Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaIIAnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:43:06 -0400
Received: from ozlabs.org ([103.22.144.67]:34059 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbaIIAnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:43:03 -0400
Message-ID: <1410223381.3223.1.camel@concordia>
Subject: Re: [PATCH 0/2] PCI/MSI: Remove arch_msi_check_device()
From: Michael Ellerman <mpe@ellerman.id.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 09 Sep 2014 10:43:01 +1000
In-Reply-To: <CAErSpo4XN01hgTUpcca=i-=LFV_bM-Cok8614LJzrOfVbx8MAA@mail.gmail.com>
References: <cover.1405160163.git.agordeev@redhat.com>
	 <20140905212528.GG8080@google.com>
	 <CAErSpo4XN01hgTUpcca=i-=LFV_bM-Cok8614LJzrOfVbx8MAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 15:27 -0600, Bjorn Helgaas wrote:
> On Fri, Sep 5, 2014 at 3:25 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Sat, Jul 12, 2014 at 01:21:06PM +0200, Alexander Gordeev wrote:
> >> Hello,
> >>
> >> This is a cleanup effort to get rid of useless arch_msi_check_device().
> >> I am not sure what were the reasons for its existence in the first place,
> >> but at the moment it appears totally unnecessary.
> >>
> >> Thanks!
> >>
> >> Cc: linuxppc-dev@lists.ozlabs.org
> >> Cc: linux-pci@vger.kernel.org
> >>
> >> Alexander Gordeev (2):
> >>   PCI/MSI/PPC: Remove arch_msi_check_device()
> >>   PCI/MSI: Remove arch_msi_check_device()
> >
> > I applied these (with Michael's ack on the first, and v2 of the second) to
> > pci/msi for v3.18, thanks!
> 
> Oh, I forgot -- if you'd rather take the first one through the PPC
> tree, you can do that and I can merge the second one later.  Let me
> know if you want to do that.

You take them all, that code shouldn't be changing much in the powerpc tree.

If the merge gets messy closer to the merge window we can always take the first
patch into the powerpc tree then.

cheers


