Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaANLl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:41:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43792 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaANLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:41:53 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52D52269.6070705@jp.fujitsu.com>
Date: Tue, 14 Jan 2014 20:41:29 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@alien8.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jingbai Ma <jingbai.ma@hp.com>
Subject: Re: [PATCH v10] x86, apic, kexec, Documentation: Add disable_cpu_apic
 kernel parameter
References: <529EE392.6060400@jp.fujitsu.com> <20131210144910.GC13909@redhat.com>
In-Reply-To: <20131210144910.GC13909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/10 23:49), Vivek Goyal wrote:
> On Wed, Dec 04, 2013 at 05:10:58PM +0900, HATAYAMA Daisuke wrote:
>> This patch set is to allow kdump 2nd kernel to wake up multiple CPUs,
>> a continueing work from:
>>
>>    [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
>>    https://lkml.org/lkml/2013/10/16/300.
>>
>> At v4, basic design has changed. Now users need to figure out initial
>> APIC ID of BSP in the 1st kernel and configures kernel parameter for
>> the 2nd kernel manually using disable_cpu_apicid kernel parameter,
>> which is newly introduced by this patch set. This design is more
>> flexible than the previous version in that we no longer have to rely
>> on ACPI/MP table to get initial APIC ID of BSP.
>>
>> Sorry, this patch set have not include in-source documentation
>> requested by Borislav Petkov yet, but I'll post it later separately,
>> which would be better to focus on documentation reviewing.
>
> Hi hpa,
>
> Can you please consider this patch for inclusion.
>
> Thanks
> Vivek
>

Hello HPA,

Could you please give me a next feedback for inclusion?

This patch set has already been acked by Vivek and now I'm waiting for a reaction of x86 maintainers.

-- 
Thanks.
HATAYAMA, Daisuke

