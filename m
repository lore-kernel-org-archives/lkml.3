Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3JRNlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:41:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:13053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3JRNlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394972383"
Message-ID: <52613A1F.5000609@linux.intel.com>
Date: Fri, 18 Oct 2013 06:39:43 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH v10 00/12] rework arch/x86/platform/[mrst => intel-mid]
References: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com> <20131018060929.GB3411@gmail.com>
In-Reply-To: <20131018060929.GB3411@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 10/17/2013 11:09 PM, Ingo Molnar wrote:
>
> * David Cohen <david.a.cohen@linux.intel.com> wrote:
>
>> David Cohen (3):
>>    intel-mid: sfi: allow struct devs_id.get_platform_data to be NULL
>>    x86: intel-mid: add section for sfi device table
>>    intel_mid: move board related codes to their own platform_<device>.*
>>      files
>>
>> Fengguang Wu (1):
>>    pci: intel_mid: return true/false in function returning bool
>>
>> Kuppuswamy Sathyanarayanan (8):
>>    mrst: Fixed printk/pr_* related issues
>>    mrst: Fixed indentation issues
>>    intel_mid: Renamed *mrst* to *intel_mid*
>>    intel_mid: Renamed *mrst* to *intel_mid*
>>    intel_mid: Refactored sfi_parse_devs() function
>>    intel_mid: Added custom device_handler support
>>    intel_mid: Added custom handler for ipc devices
>>    intel_mid: Moved SFI related code to sfi.c
>
> Btw., when submitting a series _please_ harmonize the patch titles.
>
> 1)
>
> Verbs should be present tense, i.e.:
>
> ->   intel_mid: Renamed *mrst* to *intel_mid*
> ->   intel_mid: Renamed *mrst* to *intel_mid*
> +>   intel_mid: Rename *mrst* to *intel_mid*
> +>   intel_mid: Rename *mrst* to *intel_mid*
>
> 2)
>
> Use consistent capitalization:
>
> ->   pci: intel_mid: return true/false in function returning bool
> +>   pci: intel_mid: Return true/false in function returning bool
>
> 3)
>
> Use standard, consistent subsystem prefixes:
>
> ->   x86: intel-mid: add section for sfi device table
> ->   intel_mid: Renamed *mrst* to *intel_mid*
> +>    x86/intel-mid: Add section for sfi device table
> +>    x86/intel/mid: Rename *mrst* to *intel_mid*
>
> etc.

Thanks for the suggestion. I'll take care of it next time.

Br, David Cohen
