Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3GWA1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:27:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53339 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3GWA1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:27:45 -0400
MIME-Version: 1.0
In-Reply-To: <1373436657.7970.1.camel@dabdike>
References: <20130709203927.31676.35169.stgit@amt.stowe>
	<1373404695.18560.17.camel@dabdike>
	<CAHtARFHbEz8UQUjh5cPSFYDxqW93EmFz7aiQ=91hfkDj0fCWdQ@mail.gmail.com>
	<1373436657.7970.1.camel@dabdike>
Date: Mon, 22 Jul 2013 17:27:44 -0700
Message-ID: <CAHtARFFWaMGfutTS4h3hrV8KDOf=gtk3Z3uOUQzoOAERoG1TPg@mail.gmail.com>
Subject: Re: [PATCH 0/3] [SCSI] megaraid: Remove local (struct pci_dev) pdev's
From: adam radford <aradford@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Myron Stowe <myron.stowe@redhat.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 11:10 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2013-07-09 at 15:12 -0700, adam radford wrote:
>> On Tue, Jul 9, 2013 at 2:18 PM, James Bottomley
>> > Adam, you do drive by coding on this for LSI ... ack or reject, please.
>
>> I have just now located my box of MegaRAID Parallel SCSI controllers.
>> I will review and test the patch series from Myron and respond by next Monday.
>
> Thanks,
>
> James
>
>

Unfortunately my box of MegaRAID Parallel SCSI controllers only
contains only cards intended for megaraid_mbox.c (I tested all 20 of
them),

and does not contain any of the following really old Symbios based
megaraid cards:

static struct pci_device_id megaraid_pci_tbl[] = {
        {PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
                PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
        {PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
                PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
        {PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
                PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
        {0,}
};

which I had located previously before the company headquarters moved.
 I cannot currently locate any of the above 3 controllers anywhere at
LSI headquarters after an exhaustive search, so I cannot test the
patches to megaraid.c from Myron @ RedHat.

Myron, do you actually have the hardware and have you tested the
patches yourself ?

-Adam
