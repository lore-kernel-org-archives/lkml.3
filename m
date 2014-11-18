Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaKRM6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:58:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:38614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaKRM6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:58:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="609744225"
Message-ID: <546B4278.6000002@linux.intel.com>
Date: Tue, 18 Nov 2014 20:58:32 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch Part3 v3 00/38] Enable hierarchy irqdomian on x86 platforms
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com> <20141118105145.GC3762@8bytes.org>
In-Reply-To: <20141118105145.GC3762@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 18:51, Joerg Roedel wrote:
> Hi Jiang,
> 
> On Sun, Nov 09, 2014 at 02:13:00AM +0800, Jiang Liu wrote:
>> This is the last part to enable support of hierarchy domain on x86
>> platforms.
>>
>> It first converts IOAPIC to support hierarchy irqdomain, then cleans
>> up all unused code and interfaces. It also introduces a kernel boot
>> parameter to configure CPU vector allocation policies.
>>
>> It's based on my previous patch set at:
>> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg760868.html
>> And you may access it at:
>> https://github.com/jiangliu/linux.git irqdomain/p3v3
>>
>> It has been tested on Intel 64-bit server and 32-bit laptop. It also
>> passes Fengguang's 0day tests. Helps are welcomed for testing:
>> 1) Intel MID platform
>> 2) Intel CE or OLPC platforms
>>
>> Patch 1-3 kills pre_init_apic_IRQ0().
>> Patch 4-9 convert IOAPIC to use hierarch irqdomain
>> Patch 10-36 clean up code, unused interfaces etc.
>> Patch 37-38 introduces a mechanism to configure CPU vector allocation
>> 	policies.
> 
> Did some more testing on my machines and it looks good now, no more boot
> panics or other anomalies. So feel free to add my
> 
> Tested-by: Joerg Roedel <jroedel@suse.de>
Thanks, Joerg:)
