Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaIYIRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:17:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42602 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIYIR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:17:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5423CF3B.4050107@jp.fujitsu.com>
Date: Thu, 25 Sep 2014 17:15:55 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC Part2 v1 00/21] Enable hierarchy irqdomian on x86 platforms
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <542279D0.1040603@jp.fujitsu.com> <alpine.DEB.2.10.1409242122380.4604@nanos>
In-Reply-To: <alpine.DEB.2.10.1409242122380.4604@nanos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/25 4:25), Thomas Gleixner wrote:
> On Wed, 24 Sep 2014, Yasuaki Ishimatsu wrote:
>> I cannot imagine why the feature makes x86 irq architecture much more clear
>> and more easy to maintain in this description. Of course, I have read the
>> following threads:
>>
>> https://lkml.org/lkml/2014/9/11/101
>

> Here is the long version of the idea:
>
>       https://lkml.org/lkml/2014/8/26/707

This is very helpful for the understanding of this feature.

Thanks,
Yasuaki Ishimatsu

>
> Short version is:
>
> Separate the irq handling entities in a clear layered way instead of
> having vector/[io]apic specific knowledge/data in places like msi,
> remap etc.
>
> Thanks,
>
> 	tglx
>


