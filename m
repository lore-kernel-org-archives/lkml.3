Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3AJXes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:34:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37231 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab3AJXeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:34:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance, v2
Date: Fri, 11 Jan 2013 00:40:30 +0100
Message-ID: <3595317.Eh4AyqPa3o@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXmOyWYhkc2fbjBvUqBFh7Ktf5E9X6Z8x0HguUdm8+mRw@mail.gmail.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <1910593.f2RrgAtJJO@vostro.rjw.lan> <CAE9FiQXmOyWYhkc2fbjBvUqBFh7Ktf5E9X6Z8x0HguUdm8+mRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 10, 2013 02:54:00 PM Yinghai Lu wrote:
> On Wed, Jan 9, 2013 at 3:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>  > arch/ia64/pci/pci.c        |    8 ++++++++
>  > arch/x86/include/asm/pci.h |    3 +++
>  >  arch/x86/pci/acpi.c        |    9 +++++++++
>  > drivers/acpi/pci_root.c    |   18 ------------------
>  > drivers/pci/pci-acpi.c     |   19 -------------------
>  >  drivers/pci/probe.c        |   16 ++++++++++++++++
>  >  include/acpi/acpi_bus.h    |    1 -
>  >  include/linux/pci.h        |    2 ++
>  >  8 files changed, 38 insertions(+), 38 deletions
> ...
> > I'll wait for comments from the others, if any, and put it into my acpi-scan
> > branch after a couple of days.  It doesn't need to be there technically, but
> > it's kind of related.
> 
> looks like you put it into acpi-scan-next instead.
> 
> and it does touch pci code.
> 
> can you put it in to acpi-scan ? so Bjorn could pull it again to pci/next.

I will tomorrow.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
