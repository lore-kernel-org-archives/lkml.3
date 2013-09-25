Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3IYNiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:38:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:8882 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab3IYNiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:38:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,978,1371106800"; 
   d="scan'208";a="406964302"
Message-ID: <5242E6FF.50800@intel.com>
Date: Wed, 25 Sep 2013 21:37:03 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: lenb@kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI/ACPI: Convert ACPI PCI Hot Plug core debug fuction
 to dynamic debug function
References: <1378783035-15681-1-git-send-email-tianyu.lan@intel.com> <1378783035-15681-2-git-send-email-tianyu.lan@intel.com> <20130925001902.GF9302@google.com>
In-Reply-To: <20130925001902.GF9302@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 08:19 AM, Bjorn Helgaas wrote:
> On Mon, Sep 09, 2013 at 11:17:15PM -0400, tianyu.lan@intel.com wrote:
>> From: Lan Tianyu <tianyu.lan@intel.com>
>>
>> This patch is to use pr_debug/info/warn/err to replace acpiphp debug
>> functions and remove module's debug param.
>> ...
>
>>   /* local variables */
>> @@ -61,9 +60,7 @@ static struct acpiphp_attention_info *attention_info;
>>   MODULE_AUTHOR(DRIVER_AUTHOR);
>>   MODULE_DESCRIPTION(DRIVER_DESC);
>>   MODULE_LICENSE("GPL");
>> -MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
>>   MODULE_PARM_DESC(disable, "disable acpiphp driver");
>> -module_param_named(debug, acpiphp_debug, bool, 0644);
>
> I have notes about booting with the "acpiphp.debug" parameter to turn
> on debugging.  Can you tell me the way to do the equivalent with
> dynamic debug?  I'll add that to the changelog before merging this.
Hi Bjorn:
	Sure, the counterparts of dynamic debug are "acpiphp.dyndbg=+p" and 
"acpiphp_ibm.dyndbg=+p" parameters. Thanks to add them.

>
> Bjorn
>

