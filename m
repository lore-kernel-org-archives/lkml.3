Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaACWZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:25:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33520 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbaACWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:25:10 -0500
Message-ID: <52C7389C.6000902@zytor.com>
Date: Fri, 03 Jan 2014 14:24:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH tip/efi-kexec] x86: setup.c build fix
References: <20140103035648.GA5291@darkstar.nay.redhat.com> <20140103144044.GD2618@console-pimps.org>
In-Reply-To: <20140103144044.GD2618@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 06:40 AM, Matt Fleming wrote:
> On Fri, 03 Jan, at 11:56:49AM, Dave Young wrote:
>> In case without CONFIG_EFI, there will be below build error:
>>    arch/x86/built-in.o: In function `setup_arch':
>>>> (.init.text+0x9dc): undefined reference to `parse_efi_setup'
>>
>> Thus fix it by adding blank inline function in asm/efi.h
>> Also remove an unused declaration for variable efi_data_len.
>>
>> Signed-off-by: Dave Young <dyoung@redhat.com>
>> ---
>>  arch/x86/include/asm/efi.h |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Thanks Dave. I picked up both patches.
> 

Something I should be pulling?

	-hpa

