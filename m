Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3FFRi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:38:26 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62293 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3FFRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130606173419.GA8186@google.com>
References: <20130606173419.GA8186@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Jun 2013 11:38:03 -0600
Message-ID: <CAErSpo7fvMDFHP2BcDGeOrjFaqRYf+d_0YwHyX3ccgrkpXaTyA@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for v3.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, linux-kernel]

On Thu, Jun 6, 2013 at 11:34 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Hi Linus,
>
> Here's another fix for v3.10.  This fixes a crash when booting a 32-bit
> kernel via the EFI boot stub.
>
> Bjorn
>
>
> The following changes since commit f3f011750a18abc389ef1b0d504fbeeacf641919:
>
>   Revert "x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0" (2013-05-20 10:20:21 -0600)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.10-fixes-3
>
> for you to fetch changes up to 65694c5aaddfedd9da082e4e150cafc6b3fc8a6a:
>
>   x86/PCI: Map PCI setup data with ioremap() so it can be in highmem (2013-06-05 10:50:04 -0600)
>
> ----------------------------------------------------------------
> PCI update for v3.10:
>
>   PCI ROM from EFI
>       x86/PCI: Map PCI setup data with ioremap() so it can be in highmem
>
> ----------------------------------------------------------------
> Matt Fleming (1):
>       x86/PCI: Map PCI setup data with ioremap() so it can be in highmem
>
>  arch/x86/pci/common.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
