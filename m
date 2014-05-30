Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbaE3Odr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:33:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55307 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaE3Odo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140528223637.GY11907@google.com>
References: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
 <1401117492-2870-13-git-send-email-andreas.noever@gmail.com> <20140528223637.GY11907@google.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Fri, 30 May 2014 16:33:20 +0200
Message-ID: <CAMxnaaVwSev1EuEUghxFFzp0M2mMy3qYHgJA+rXpLhiJQH7Psg@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] pci: Add pci_fixup_suspend_late quirk pass.
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Greg KH <greg@kroah.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:36 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, May 26, 2014 at 05:18:09PM +0200, Andreas Noever wrote:
>
> Please adjust the subject to match the drivers/pci convention, i.e., change
>
>   pci: Add pci_fixup_suspend_late quirk pass.
>
> to
>
>   PCI: Add pci_fixup_suspend_late quirk pass
>
>> Add pci_fixup_suspend_late as a new pci_fixup_pass. The pass is called
>> from suspend_noirq and poweroff_noirq. Using the same pass for suspend
>> and hibernate is consistent with resume_early which is called by
>> resume_noirq and restore_noirq.
>>
>> The new quirk pass is required for Thunderbolt support on Apple
>> hardware.
>>
>> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks for reading through the series. I will make those changes for
the next version.

> I assume you'll merge this along with the rest of the series, not through
> my PCI tree.
Agreed, since I am the only user of this pass. Can you tell me whose
tree normally carries new drivers?

Thanks,
Andreas
