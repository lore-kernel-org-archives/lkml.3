Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAPGY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:24:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:37522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaAPGYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:24:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="459659425"
Message-ID: <52D77B36.1040506@linux.intel.com>
Date: Wed, 15 Jan 2014 22:24:54 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86, apic: Make disabled_cpu_apicid static read_mostly,
 fix typos
References: <20140115182511.GA22737@gmail.com> <tip-5b4d1dbc24bb6fd7179ada0f47be34e27e64decb@git.kernel.org> <52D763BC.8050909@jp.fujitsu.com> <52D773F7.7000108@zytor.com> <52D77A49.5060905@jp.fujitsu.com>
In-Reply-To: <52D77A49.5060905@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 10:20 PM, HATAYAMA Daisuke wrote:
> (2014/01/16 14:53), H. Peter Anvin wrote:
>> On 01/15/2014 08:44 PM, HATAYAMA Daisuke wrote:
>>>
>>> This is not typo in my intention.
>>>
>>> generic_processor_info() has two more cases where it ignores cpus.
>>> In either cases, printed messages are tagged with "ACPI" because this
>>> function is called when parsing ACPI MADT table in acpi_boot_init();
>>> this function is also being used to parse other kind of tables but
>>> the "ACPI" tag would mean that the function was first for ACPI only.
>>>
>>
>> But it has nothing to do with ACPI -- it is an APIC ID from the command
>> line -- so that would be actively misleading.
>>
>>     -hpa
>>
> 
> I never disagree to the fix itself. I wanted to explain why I wrote so.
> 
> I thought it was better to unify tags in the same function because they
> should bleong to the same component, here I mean ACPI, but it's better
> to avoid the confusion, which is bigger impact.
> 

Indeed.  All good now.

	-hpa

