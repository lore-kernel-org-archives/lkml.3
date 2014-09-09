Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaIICdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:33:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:26198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaIICdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,490,1406617200"; 
   d="scan'208";a="570306884"
Message-ID: <540E66E0.30508@linux.intel.com>
Date: Tue, 09 Sep 2014 10:33:04 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Len Brown <lenb@kernel.org>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch v4 04/16] ACPI: Rename processor_core.c as apic_id.c
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1957879.bE3ICM6HKO@vostro.rjw.lan> <540DA653.2000901@linaro.org> <1537817.rgZoClELVE@vostro.rjw.lan>
In-Reply-To: <1537817.rgZoClELVE@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael and Hanjun,
	Thanks for your review. I will keep the original file name
in next version.
Regards!
Gerry

On 2014/9/9 5:00, Rafael J. Wysocki wrote:
> On Monday, September 08, 2014 08:51:31 PM Hanjun Guo wrote:
>> Hi Gerry, Rafael,
>>
>> On 2014年09月08日 06:37, Rafael J. Wysocki wrote:
>>> On Thursday, August 28, 2014 10:22:29 AM Jiang Liu wrote:
>>>> Now all code in processor_core.c is APIC ID related, so rename it as
>>>> apic_id.c. Later IOAPIC ID related code will be added into apic_id.c.
>>> Actually, I'm not sure about this one.
>>>
>>> Renames like this make it difficult to backport things in general
>>> and kind of break "git blame", so do we have to do that?
>>>
>>> What's wrong with leaving the name as is and adding a comment
>>> about the contents being related to IOAPIC ID?
>>
>> It will be thankful for not renaming the file into apic_id.c, because apic id is x86 specific,
>> and platform like ARM will also add some code to get cpu hardware id via GICC structure
>> in MADT table in that file, apic id is not a generic name for both x86 and ARM, I prefer to
>> keep it as it is :)
> 
> Well, that's a good argument too.
> 
> Rafael
> 
