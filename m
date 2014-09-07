Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaIGTHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 15:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaIGTHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 15:07:12 -0400
Date: Sun, 7 Sep 2014 21:07:00 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 0/2] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140907190659.GA23249@dhcp-27-160.brq.redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
 <20140905212528.GG8080@google.com>
 <CAErSpo4XN01hgTUpcca=i-=LFV_bM-Cok8614LJzrOfVbx8MAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4XN01hgTUpcca=i-=LFV_bM-Cok8614LJzrOfVbx8MAA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 03:27:49PM -0600, Bjorn Helgaas wrote:
> > I applied these (with Michael's ack on the first, and v2 of the second) to
> > pci/msi for v3.18, thanks!

Hi Bjorn,

I resent a series with updates that fix kbuild robot errors.
Hopefully, the rebase for pci/msi would not cause trouble for anyone.

> Oh, I forgot -- if you'd rather take the first one through the PPC
> tree, you can do that and I can merge the second one later.  Let me
> know if you want to do that.

Nah, your treee is just fine.

Thanks!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
