Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967524Ab3DRXmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:42:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966999Ab3DRXmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:42:44 -0400
Message-ID: <517084DA.4090401@zytor.com>
Date: Thu, 18 Apr 2013 16:42:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
CC: Matt Fleming <matt@console-pimps.org>, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51706E8A.7030909@nexus-software.ie>
In-Reply-To: <51706E8A.7030909@nexus-software.ie>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> "UEI" is Celtic for "We missed DOS so we burned it into your ROMS"
> 
> I love it "maith an fear"
> 
>> There are currently only two situations where we need to map EFI Boot
>> Service regions,
>>
>>    1. To workaround the firmware bug described in 916f676f8
>>    2. To access the ACPI BGRT image
>>
>> but since we haven't seen an i386 implementation that requires either,
>> this simple fix should suffice for now. Item 2. above does still work on
>> i386 provided that the BGRT image is not in highmem.
> 
> Matt, Peter, Josh, Darren.
> 
> Given it's not possible to guarantee someone won't stuff a BGRT into
> EFI_BOOT_MEMORY >= highmem eventually (and indeed the axioms of the
> universe pretty much guarantee eventually it will be so) - I'd suggest
> version 2.
> 

Quite frankly, it is quite likely.

> A kernel parameter - rather than a probe for BGRT - since we anticipate
> BIOS bugs on the way.

Pardon?  Kernel parameter for what?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

