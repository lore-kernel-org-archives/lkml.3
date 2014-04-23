Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaDWInx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:43:53 -0400
Received: from thoth.sbs.de ([192.35.17.2]:43835 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaDWInu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:43:50 -0400
Message-ID: <53577D3C.5060103@siemens.com>
Date: Wed, 23 Apr 2014 10:43:40 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Carlo Vitucci <vitucci.carlo@gmail.com>, jailhouse-dev@googlegroups.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Sabony, Mazda" <Mazda.Sabony@amd.com>
Subject: Re: Developer wanted: AMD64 port of Jailhouse hypervisor
References: <534C2884.7050004@siemens.com> <b95ba76d-c3a9-458e-b9a9-10ca28886d55@googlegroups.com>
In-Reply-To: <b95ba76d-c3a9-458e-b9a9-10ca28886d55@googlegroups.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-23 08:21, Carlo Vitucci wrote:
> Il giorno lunedì 14 aprile 2014 20:27:16 UTC+2, J. Kiszka ha scritto:
>> Hi all,
>>
>>
>>
>> so far the Linux-based Jailhouse hypervisor [1] is only available for
>>
>> Intel x86 CPUs. I'm now very happy to announce that AMD is offering to
>>
>> sponsor the initial port of Jailhouse to the AMD64 architecture. Our
>>
>> resources here are unfortunately bound to different tasks, but if anyone
>>
>> out there with the required skills is interested in working on this
>>
>> project, just reply to this email or contact me and Mazda directly.
>>
>>
>>
>> The work to be done is manageable: we basically need corresponding
>>
>> implementations of vmx.c and vtd.c in the current Jailhouse code base -
>>
>> provided our existing abstractions were done right. Someone familiar
>>
>> with virtualization on x86 in general and, ideally, even on AMD
>>
>> processors should be able to complete this task within a couple of weeks.
>>
>>
>>
>> For more details on the Jailhouse architecture and implementations, see
>>
>> our slowly growing Documentation folder in the source tree or simply ask
>>
>> on the mailing list.
>>
>>
>>
>> Jan
>>
>>
>>
>> [1] https://github.com/siemens/jailhouse
>>
>>
>>
>> -- 
>>
>> Siemens AG, Corporate Technology, CT RTC ITP SES-DE
>>
>> Corporate Competence Center Embedded Linux
> 
> Hello jailhouse,
>  just a thought, if I could. AMD64 is not officially delivered and one
>  of the most important new features, that is the direct interrupt delivery,
>  is without a final specification. in other words, ARMv8 is the only suitable
>  architecture for Jailhouse porting, but there is still a bit fog around.

I'm not sure if I got your point yet: AMD64 stands for the
well-established x86-64 architecture with AMD-specific parts like the
virtualization extensions. All these transistors and specs are broadly
available for years.

Regarding direct interrupt delivery: on Intel, we do not depend on
specific hardware support to provide this feature, and I bet we can port
that approach to AMD as well.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
