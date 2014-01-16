Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaAPCld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:41:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:47508 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaAPClb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:41:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="465880117"
Message-ID: <52D746D9.7030206@linux.intel.com>
Date: Wed, 15 Jan 2014 18:41:29 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
References: <1389473370-1940-1-git-send-email-bp@alien8.de> <1389473370-1940-2-git-send-email-bp@alien8.de> <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com> <52D57F75.7060308@zytor.com> <20140115011609.GD23767@dhcp-16-126.nay.redhat.com> <52D6970D.3050701@zytor.com> <20140116014457.GA3807@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20140116014457.GA3807@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/2014 5:44 PM, Dave Young wrote:
> On 01/15/14 at 06:11am, H. Peter Anvin wrote:
>> On 01/14/2014 05:16 PM, Dave Young wrote:
>>>>
>>>> Why the [Finnish] do you feel that information needs to be in a
>>>> different form because it is (currently!) not available as a module?
>>>
>>> I think moving them to comment can avoid including extra linux/module.h
>>>
>>
>> And that matters, why?
>
> At least the code will be cleaner and kernel size will be a bit smaller?
>

making something harder to grep and less standardized is hardly cleaner
and these things compile to nothing for non-modules.


