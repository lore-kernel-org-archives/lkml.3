Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3JAUKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:10:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:3064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab3JAUKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1015,1371106800"; 
   d="scan'208";a="386391362"
Message-ID: <524B2D36.3040803@linux.intel.com>
Date: Tue, 01 Oct 2013 13:14:46 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: cjb@laptop.org, bhelgaas@google.com, adrian.hunter@intel.com,
        wfp5p@virginia.edu, g.liakhovetski@gmx.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] pci_id: add Intel Merrifield mmc pci id
References: <1380657633-19543-1-git-send-email-david.a.cohen@linux.intel.com> <20131001200755.GA28165@kroah.com>
In-Reply-To: <20131001200755.GA28165@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 01:07 PM, Greg KH wrote:
> On Tue, Oct 01, 2013 at 01:00:32PM -0700, David Cohen wrote:
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>   include/linux/pci_ids.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index 97fbecd..2a89103 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -2551,6 +2551,7 @@
>>   #define PCI_DEVICE_ID_INTEL_MFD_EMMC0	0x0823
>>   #define PCI_DEVICE_ID_INTEL_MFD_EMMC1	0x0824
>>   #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
>> +#define PCI_DEVICE_ID_INTEL_MRFL_MMC	0x1190
>
> Please read the top of this file for why you shouldn't be adding new
> device ids to it.

Thanks for the reply. I am sending new patch.

Br, David

>
> thanks,
>
> greg k-h
>

