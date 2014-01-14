Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaANSTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:19:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54483 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaANSTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:19:00 -0500
Message-ID: <52D57F75.7060308@zytor.com>
Date: Tue, 14 Jan 2014 10:18:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
References: <1389473370-1940-1-git-send-email-bp@alien8.de> <1389473370-1940-2-git-send-email-bp@alien8.de> <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20140114014003.GB4327@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 05:40 PM, Dave Young wrote:
> On 01/13/14 at 06:48am, Arjan van de Ven wrote:
>> On 1/13/2014 4:23 AM, Dave Young wrote:
>>>>
>>>>> How about do not limit to only if (pgd) case, instead do something
>>>>> like below: set dump_to_dmesg as a module parameter
>>>>
>>>> X86_PTDUMP is not a module.
>>>
>>> Hmm, I just see the module macros in the code, since it's a bool Kconfig
>>> I think the dump_pagetables.c need a cleanup,
>>> remove the #include <linux/module.h> and below lines:
>>> MODULE_LICENSE("GPL");
>>> MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
>>> MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");
>>
>> personally I consider it good form to always have this kind of information in .c files,
>> regardless of the KConfig side of thing...
> 
> I agree it's good to add these infomation, but they can be added in comment.
> IMHO it will be better in that way.
> 

Why the [Finnish] do you feel that information needs to be in a
different form because it is (currently!) not available as a module?

	-hpa


