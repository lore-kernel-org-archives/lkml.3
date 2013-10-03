Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3JCQFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:05:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:26915 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab3JCQFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1026,1371106800"; 
   d="scan'208";a="413583627"
Message-ID: <524D9574.20702@linux.intel.com>
Date: Thu, 03 Oct 2013 09:04:04 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: alexander.shishkin@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] usb: chipidea: add Intel Clovertrail pci id
References: <1380663178-24218-1-git-send-email-david.a.cohen@linux.intel.com> <1380663178-24218-2-git-send-email-david.a.cohen@linux.intel.com> <20131003052134.GA1312@kroah.com>
In-Reply-To: <20131003052134.GA1312@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 10/02/2013 10:21 PM, Greg KH wrote:
> On Tue, Oct 01, 2013 at 02:32:58PM -0700, David Cohen wrote:
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>   drivers/usb/chipidea/ci_hdrc_pci.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
>> index 08a724b..d514332 100644
>> --- a/drivers/usb/chipidea/ci_hdrc_pci.c
>> +++ b/drivers/usb/chipidea/ci_hdrc_pci.c
>> @@ -129,6 +129,11 @@ static DEFINE_PCI_DEVICE_TABLE(ci_hdrc_pci_id_table) = {
>>   		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0829),
>>   		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
>>   	},
>> +	{
>> +		/* Intel Clovertrail */
>> +		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe006),
>> +		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
>> +	},
>
> Can this go into 3.12-final, and any other stable kernel releases as
> well?  Or does this platform also need other fixes that aren't in 3.10
> and 3.11?

This was tested on 3.10+
It might work on 3.4 but it's not validated. I can test it if we care 
about chipidea on 3.4.

Br, David

>
> thanks,
>
> greg k-h
>

