Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3AJWyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:54:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36919 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3AJWyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:54:03 -0500
MIME-Version: 1.0
In-Reply-To: <1910593.f2RrgAtJJO@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<16795012.QL1jNHE7JM@vostro.rjw.lan>
	<CAErSpo473rZOBERaMJV74rfGZXSuBdiPtX=mXmcLmO=CRB4P_g@mail.gmail.com>
	<1910593.f2RrgAtJJO@vostro.rjw.lan>
Date: Thu, 10 Jan 2013 14:54:00 -0800
X-Google-Sender-Auth: smj0cAgd5oytbH7v-6AqZ2Hx-_c
Message-ID: <CAE9FiQXmOyWYhkc2fbjBvUqBFh7Ktf5E9X6Z8x0HguUdm8+mRw@mail.gmail.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in
 advance, v2
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 3:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

 > arch/ia64/pci/pci.c        |    8 ++++++++
 > arch/x86/include/asm/pci.h |    3 +++
 >  arch/x86/pci/acpi.c        |    9 +++++++++
 > drivers/acpi/pci_root.c    |   18 ------------------
 > drivers/pci/pci-acpi.c     |   19 -------------------
 >  drivers/pci/probe.c        |   16 ++++++++++++++++
 >  include/acpi/acpi_bus.h    |    1 -
 >  include/linux/pci.h        |    2 ++
 >  8 files changed, 38 insertions(+), 38 deletions
...
> I'll wait for comments from the others, if any, and put it into my acpi-scan
> branch after a couple of days.  It doesn't need to be there technically, but
> it's kind of related.

looks like you put it into acpi-scan-next instead.

and it does touch pci code.

can you put it in to acpi-scan ? so Bjorn could pull it again to pci/next.

I like to rebase my patches on top of pci/next.

Thanks

Yinghai
