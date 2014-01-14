Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaANK6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:58:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaANK6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:58:37 -0500
Message-ID: <52D5184B.6080406@redhat.com>
Date: Tue, 14 Jan 2014 05:58:19 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Toshi Kani <toshi.kani@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, linux-acpi@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] x86, acpi memory hotplug, add parameter to disable memory
 hotplug
References: <1389650161-13292-1-git-send-email-prarit@redhat.com>  <CAHGf_=pX303E6VAhL+gApSQ1OsEQHqTuCN8ZSdD3E54YAcFQKA@mail.gmail.com>  <52D47999.5080905@redhat.com> <52D48EC4.5070400@jp.fujitsu.com> <1389663689.1792.268.camel@misato.fc.hp.com> <52D4A469.9090100@jp.fujitsu.com>
In-Reply-To: <52D4A469.9090100@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/13/2014 09:43 PM, Yasuaki Ishimatsu wrote:
> (2014/01/14 10:41), Toshi Kani wrote:
>> On Tue, 2014-01-14 at 10:11 +0900, Yasuaki Ishimatsu wrote:
>>   :
>>>>> I think we need a knob manually enable mem-hotplug when specify memmap. But
>>>>> it is another story.
>>>>>
>>>>> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>>
>>>> As mentioned, self-NAK.  I have seen a system that I needed to specify
>>>> memmap=exactmap & had hotplug memory.  I will only keep the acpi_no_memhotplug
>>>> option in the next version of the patch.
>>>
>>>
>>> Your following first patch is simply and makes sense.
>>>
>>> http://marc.info/?l=linux-acpi&m=138922019607796&w=2
>>>
>>
>> In this option, it also requires changing kexec-tools to specify the new
>> option for kdump.  It won't be simpler.
> 
> Hmm.
> I use memm= boot option and hotplug memory for memory hot-remove.
> At least, the patch cannot be accepted.

Thanks for the information Yasuaki.  I will resubmit my first patch that only
adds the kernel parameter.

P.

> 
> Thanks,
> Yasuaki Ishimatsu
> 
>>
>> Thanks,
>> -Toshi
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
