Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3LDDJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 22:09:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49856 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3LDDJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 22:09:16 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <529E9CA6.5040200@jp.fujitsu.com>
Date: Wed, 04 Dec 2013 12:08:22 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@alien8.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jingbai Ma <jingbai.ma@hp.com>, Jerry Hoemann <jerry.hoemann@hp.com>
Subject: Re: [PATCH v9] x86, apic, kexec, Documentation: Add disable_cpu_apic
 kernel parameter
References: <529D34AA.1000809@jp.fujitsu.com> <20131203152536.GE4251@redhat.com>
In-Reply-To: <20131203152536.GE4251@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/04 0:25), Vivek Goyal wrote:
> On Tue, Dec 03, 2013 at 10:32:26AM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 50680a5..dd77bec 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -774,6 +774,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>   	disable=	[IPV6]
>>   			See Documentation/networking/ipv6.txt.
>>
>> +	disable_cpu_apicid= [X86,APIC,KEXEC,SMP]
>
> Hi Hatayama,
>
> We are almost there. A minor nit. Why have we specified KEXEC here. This
> parameter disabled_cpu_apicid does not seem to dependon CONFIG_KEXEC?
>
> Jerry, this patch looks good to me. Does it work on your system?
>

Because primary user for the option is currently kexec/kdump only.

I referred to acpi_rsdp description:

         acpi_rsdp=      [ACPI,EFI,KEXEC]
                         Pass the RSDP address to the kernel, mostly used
                         on machines running EFI runtime service to boot the
                         second kernel for kdump.

-- 
Thanks.
HATAYAMA, Daisuke

