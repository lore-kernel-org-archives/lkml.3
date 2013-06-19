Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab3FSRir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:38:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39324 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FSRiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:38:46 -0400
Message-ID: <51C1EC90.9030802@zytor.com>
Date: Wed, 19 Jun 2013 12:38:24 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
References: <1371491416-11037-1-git-send-email-bp@alien8.de> <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic> <51C1E996.9070209@zytor.com> <20130619173721.GI28300@pd.tnic>
In-Reply-To: <20130619173721.GI28300@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 12:37 PM, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 12:25:42PM -0500, H. Peter Anvin wrote:
>> On 06/19/2013 08:02 AM, Borislav Petkov wrote:
>>>
>>> And yet there are the Macs which reportedly cannot stomach this.
>>>
>> No, the reports are that if you use the 1:1 map as the primary address
>> on Macs the drivers fail... not that you can't have a 1:1 map.
> 
> That's what I meant: ... cannot stomach when the 1:1 map is shoved down
> SetVirtualAddressMap.
> 
> The thing is, if we want to have both the 1:1 map and the high map
> during an EFI runtime call, we would need to *always* switch the
> pagetable for an EFI runtime call and establish both mappings in
> ->trampoline_pgd beforehand.
> 

I thought that was the plan?

	-hpa

