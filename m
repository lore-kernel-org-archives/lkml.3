Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKLI6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:58:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaKLI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5LELkH=9WAq5MDE6fkVJvPK3miQtqrMnRHY7QyLWigUg@mail.gmail.com>
References: <1415702040-2790-1-git-send-email-ming.lei@canonical.com>
	<20141111122901.GA4419@red-moon>
	<CACVXFVNAc9axtESmo1zGZ3GMquTzjzWR3jx-b3tbhhLfQDDRcg@mail.gmail.com>
	<20141111182418.GA5507@red-moon>
	<CACVXFVPzo2qNGa5DWESS3TXor=u82_SxHb+xzrBCRXtcQxq4Cg@mail.gmail.com>
	<CAErSpo5LELkH=9WAq5MDE6fkVJvPK3miQtqrMnRHY7QyLWigUg@mail.gmail.com>
Date: Wed, 12 Nov 2014 16:58:00 +0800
Message-ID: <CACVXFVN1HmyaiR7fXAxjwkBBJJZdW5bNpujfrPPeWRGZ=8FOig@mail.gmail.com>
Subject: Re: [PATCH] pci: generic host: make it more generic
From: Ming Lei <ming.lei@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        alvise rigo <a.rigo@virtualopensystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:47 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Nov 11, 2014 at 7:12 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> ...
>> Do you think it is doable to introduce a option(from module
>> parameter, or device tree, ...) to let the driver and PCI core
>> ignore/bypass all pcibios handling for the generic bus?
>
> No, I don't think so.

Could you explain a bit? In VM world, it might be reasonable to
claim that there is no pcibios service or pcibios service needn't.

IMO it isn't easy to make a cross-arch PCI generic controller
driver if pcibios handling has to be involved.

Thanks,
Ming Lei
