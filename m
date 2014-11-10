Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaKJCEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 21:04:22 -0500
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:15717
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbaKJCEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 21:04:20 -0500
X-WSS-ID: 0NESWF1-07-DMB-02
X-M-MSG: 
Message-ID: <54601D09.3090902@amd.com>
Date: Mon, 10 Nov 2014 09:03:53 +0700
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch Part2 v5 21/31] PCI/MSI: Enhance core to support hierarchy
 irqdomain
References: <1415283644-2559-1-git-send-email-jiang.liu@linux.intel.com>
 <1415283644-2559-22-git-send-email-jiang.liu@linux.intel.com>
 <545EED04.4090008@amd.com> <545F1478.3040808@linux.intel.com>
In-Reply-To: <545F1478.3040808@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(24454002)(479174003)(51704005)(65956001)(65816999)(65806001)(80316001)(19580405001)(44976005)(68736004)(19580395003)(84676001)(31966008)(83506001)(15975445006)(50986999)(106466001)(76176999)(54356999)(105586002)(64126003)(59896002)(95666004)(50466002)(99396003)(120916001)(107046002)(86362001)(92726001)(92566001)(97736003)(101416001)(47776003)(20776003)(64706001)(62966003)(77156002)(77096003)(36756003)(87936001)(46102003)(4396001)(102836001)(33656002)(93886004)(21056001)(1121002)(921003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/9/14 14:15, Jiang Liu wrote:
> On 2014/11/9 12:26, Suravee Suthikulpanit wrote:
>> Hi Gerry,
>>
>> Please see my comments / questions below.
>>
>> On 11/6/14 21:20, Jiang Liu wrote:
>>> Enhance PCI MSI core to support hierarchy irqdomain, so the common
>>> code could be shared among architectures.
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>> ---
>>> Hi Thomas,
>>>      These changes are a temporary solution, I'm working on another
>>> patch set which will refine these interfaces, especially kill
>>> arch_msi_irq_domain_{set|get}_hwirq().
>>> Regards!
>>> Gerry
>>
>> Would the change includes the struct irqdomain_msi_data proposed by
>> Thomas here (https://lkml.org/lkml/2014/11/6/210)?
> Hi Suravee,
> 	I'm working on another patch set which will refine the way to
> create irqdomain for MSI. I hope will solve all issues mentioned by
> Thomas. I will post that patch set as RFC within one or two days.

Let me know if I can help.

>>
>>> [...]
>>> +static int msi_domain_alloc(struct irq_domain *domain, unsigned int
>>> virq,
>>> +                unsigned int nr_irqs, void *arg)
>>> +{
>>> +    int i, ret;
>>> +    irq_hw_number_t hwirq = arch_msi_irq_domain_get_hwirq(arg);
>>> +
>>> +    if (irq_find_mapping(domain, hwirq) > 0)
>>> +        return -EEXIST;
>>> +
>>> +    ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
>>> +    if (ret < 0)
>>> +        return ret;
>>> +
>>
>> When executing irq_domain_alloc_irqs_parent(), it triggers the following
>> warning message due to
>>
>>      WARN_ON(desc->irq_data.chip == &no_irq_chip)
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 2 PID: 912 at kernel/irq/chip.c:734
>> __irq_set_handler+0x138/0x13c()
>> Modules linked in: mlx4_core(+) rtc_efi efivarfs
>> CPU: 2 PID: 912 Comm: modprobe Not tainted 3.18.0-rc3-p2v5+ #53
>> Call trace:
>> [<fffffe00000963d4>] dump_backtrace+0x0/0x16c
>> [<fffffe0000096550>] show_stack+0x10/0x1c
>> [<fffffe000067545c>] dump_stack+0x74/0x98
>> [<fffffe00000b205c>] warn_slowpath_common+0x84/0xac
>> [<fffffe00000b2148>] warn_slowpath_null+0x14/0x20
>> [<fffffe00000ed968>] __irq_set_handler+0x134/0x13c
>> [<fffffe000042af14>] gic_irq_domain_map+0x4c/0xac
>> [<fffffe000042afd4>] gic_irq_domain_alloc+0x60/0x88
>> [<fffffe000042b374>] gicv2m_domain_alloc+0x30/0xa8
>> [<fffffe00000efc1c>] __irq_domain_alloc_irqs+0x144/0x30c
>> [<fffffe000042b58c>] gicv2m_setup_msi_irq+0xc0/0x118
>> [<fffffe000044548c>] arch_setup_msi_irq+0x34/0x60
>> [<fffffe0000445544>] arch_setup_msi_irqs+0x50/0xb0
>> [<fffffe0000445e3c>] pci_enable_msix+0x310/0x39c
>> [<fffffe0000445efc>] pci_enable_msix_range+0x34/0x9c
>> ....
>>
>> However, I think if we call irq_domain_set_hwirq_and_chip() in the
>> msi_create_irq_domain() as suggested by Thomas, that should also fix
>> this issue.
> We didn't trigger this warning on x86 because only the outer-most
> irqdomain will set irq flow handler. On ARM, the inner GIC domain
> will set irq flow handler, but the irq_data->chip for outer-most
> domain hasn't been set yet.
>
> I'm still find a way out here. Maybe we need to relax the WARN_ON().

What if we just switch the order and call the 
irq_domain_alloc_irqs_parent() after the loop? That way we can still 
keep the WARN_ON().

Suravee
