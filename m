Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3KSSeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:34:05 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50659 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KSSeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:34:02 -0500
MIME-Version: 1.0
In-Reply-To: <20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Nov 2013 11:33:41 -0700
Message-ID: <CAErSpo7mFMP+aU5rhVyhpdhWGBrB4fmP1MSg3oO4umLXziCzAw@mail.gmail.com>
Subject: Re: [PATCH 0/2] PCIe Capability accessor fixes [stable backports]
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:17 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> The following two patches fix issues reported by Yuval Mintz
> <yuvalmin@broadcom.com> and Adam Lee <adam.lee@canonical.com>.
>
> These backports are for 3.10.x and 3.11.x.
>
> 3.4.x and earlier stable kernels do not need these fixes because they
> do not have the pcie_capability_*() accessors.
>
> ---
>
> Bjorn Helgaas (2):
>       PCI: Allow PCIe Capability link-related register access for switches
>       PCI: Support PCIe Capability Slot registers only for ports with slots

Please ignore these two patches.  Myron pointed out that I need to
include a third patch from the series, so I'll repost with that one
included.

Bjorn
