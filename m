Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaCCATG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:19:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48166 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbaCCATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:19:03 -0500
Message-ID: <5313CA6B.7020505@zytor.com>
Date: Sun, 02 Mar 2014 16:18:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org> <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com> <53130A46.1010801@linux.intel.com> <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com> <5313AD1B.6050403@linux.intel.com> <20140302222654.GA17838@srcf.ucam.org> <5313B47B.6020402@linux.intel.com> <20140302231154.GA20891@srcf.ucam.org> <5313BD5A.1040409@linux.intel.com> <20140303000759.GA25085@srcf.ucam.org>
In-Reply-To: <20140303000759.GA25085@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 04:07 PM, Matthew Garrett wrote:
> On Mon, Mar 03, 2014 at 07:23:06AM +0800, Li, Aubrey wrote:
> 
>> Windows doesn't do because there is no 32/64 mixed windows and EFI on
>> the planet. Since the silicon is actually 64 bit, I failed to see a
>> reason to refuse the user install 64bit linux on it. So we encountered a
>> case windows didn't.
> 
> And we'll call the 32 bit EFI call, so what's the problem?
> 
>> So, you didn't mention BOOT_BIOS, if you don't want to add BOOT_BIOS,
>> and you also don't like DMI entires, how do you want to deal with the
>> machines requiring BOOT_BIOS to reboot their machine?
> 
> I was planning on ignoring them.
> 

I suspect we'll never get away from having a DMI table, if nothing else
because we can't test enough, but the current situation where it seems
like we need to add every since Dell box to the DMI table is clearly broken.

	-hpa

