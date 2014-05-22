Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaEVTRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:17:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47749 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaEVTRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:17:50 -0400
Date: Thu, 22 May 2014 21:17:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after
 Fam16h
Message-ID: <20140522191746.GL4383@pd.tnic>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic>
 <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:56:03AM -0600, Bjorn Helgaas wrote:
> I chose Fam16h (0x16) because it looks like that's the newest stuff
> that's in the field. I suspect things would probably work if we
> changed this patch to leave ECS disabled on some Fam16h, Fam15h, etc.,
> but that would change behavior on existing systems, which obviously
> adds some risk. I didn't think there was much benefit that makes the
> risk worthwhile.
>
> My goal is to stop needing CPU-specific changes in the future, not
> necessarily to remove the CPU-specific code we already have.
>
> Does that make sense? I'm not sure whether I understood your real
> question.

No, you got it right. I'm just wondering why only the newest stuff.
MMCONFIG is supposed to work just fine on everything from Fam10h
onwards, I'm not sure all Fam10h supported it though. Maybe Suravee can
verify that...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
