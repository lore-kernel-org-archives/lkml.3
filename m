Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaKELRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:17:39 -0500
Received: from 8bytes.org ([81.169.241.247]:40716 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbaKELRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:17:37 -0500
Date: Wed, 5 Nov 2014 12:17:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jon Mason <jdmason@kudzu.us>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Kernel NULL pointer deref in pci_get_hp_params with v3.18-rc3
Message-ID: <20141105111736.GK10744@8bytes.org>
References: <20141104162251.GF10744@8bytes.org>
 <CAErSpo4Zx8hNjJdHvJeLzj_wAJSa6WCDuJ0XYymK-QU_i+MECg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4Zx8hNjJdHvJeLzj_wAJSa6WCDuJ0XYymK-QU_i+MECg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Tue, Nov 04, 2014 at 11:38:09AM -0700, Bjorn Helgaas wrote:
> [+cc Yinghai]
> 
> On Tue, Nov 4, 2014 at 9:22 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > Hi,
> >
> > booting v3.18-rc3 (havn't tested earlier -rcs on this box) on a Xeon box
> > with a Neterion 10GBit card (vxge driver) I see the following NULL
> > pointer deref in dmesg:
> >
> > [    7.221747] vxge: Copyright(c) 2002-2010 Exar Corp.
> > [    7.221749] vxge: Driver version: 2.5.3.22640-k
> > [    7.324070] pci 0000:07:00.1: [17d5:5833] type 00 class 0x020000
> > [    7.324144] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d8
> > [    7.324162] IP: [<ffffffff8136733b>] pci_get_hp_params+0x2b/0x620
> 
> I think this is the same problem Yinghai posted a patch for:
> http://lkml.kernel.org/r/1414621570-20777-1-git-send-email-yinghai@kernel.org
> 
> I broke things with 6cd33649fa83, and I'd like to try a different fix
> than Yinghai's, so I guess I should get busy :)  Thanks for the
> reminder.

Okay, let me know if there is any patch for me to test :)


	Joerg

