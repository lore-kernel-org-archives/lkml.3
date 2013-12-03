Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3LCSYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:24:18 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52477 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3LCSYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:24:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131203033712.GA8525@kroah.com>
References: <20131129031419.GB5889@neilslaptop.think-freely.org>
 <20131129094137.GC3028@redhat.com> <20131129175336.GA6152@kroah.com>
 <CAErSpo44sQU2PbufCYF+wzpMtMPC97_FgAMQgruX9Nw3XbmL8g@mail.gmail.com> <20131203033712.GA8525@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 3 Dec 2013 11:23:51 -0700
Message-ID: <CAErSpo42MJ1VkhDdJ_AM-5hsidakcE_GQzWfV9UVT36nK_5a5A@mail.gmail.com>
Subject: Re: [PATCH] PCI: update MSI attribute file documentation
To: Greg KH <greg@kroah.com>
Cc: Veaceslav Falico <vfalico@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 8:37 PM, Greg KH <greg@kroah.com> wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Now that the MSI modes are now attribute files in sysfs, not
> subdirectories, update the documentation to reflect this.
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, I'll fold this into the patch that makes the code change, if
you don't mind.

Bjorn

> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 5210a51c90fd..a3c5a6685036 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -70,18 +70,15 @@ Date:               September, 2011
>  Contact:       Neil Horman <nhorman@tuxdriver.com>
>  Description:
>                 The /sys/devices/.../msi_irqs directory contains a variable set
> -               of sub-directories, with each sub-directory being named after a
> -               corresponding msi irq vector allocated to that device.  Each
> -               numbered sub-directory N contains attributes of that irq.
> -               Note that this directory is not created for device drivers which
> -               do not support msi irqs
> +               of files, with each file being named after a corresponding msi
> +               irq vector allocated to that device.
>
> -What:          /sys/bus/pci/devices/.../msi_irqs/<N>/mode
> +What:          /sys/bus/pci/devices/.../msi_irqs/<N>
>  Date:          September 2011
>  Contact:       Neil Horman <nhorman@tuxdriver.com>
>  Description:
>                 This attribute indicates the mode that the irq vector named by
> -               the parent directory is in (msi vs. msix)
> +               the file is in (msi vs. msix)
>
>  What:          /sys/bus/pci/devices/.../remove
>  Date:          January 2009
