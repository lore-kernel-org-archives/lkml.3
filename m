Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3GLBzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:55:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:3598 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab3GLBzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:55:20 -0400
Message-ID: <51DF61FB.9000501@huawei.com>
Date: Fri, 12 Jul 2013 09:55:07 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH -v2 1/3] PCI: introduce PCIe Device Serial Number Capability
 support
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>  <1373535825-49972-2-git-send-email-wangyijing@huawei.com> <1373552533.1349.4.camel@x61.thuisdomein>
In-Reply-To: <1373552533.1349.4.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
> [...] 
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 0fd1f15..10d190b 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -342,6 +342,7 @@ struct pci_dev {
>>  	struct list_head msi_list;
>>  	struct kset *msi_kset;
>>  #endif
>> +	u64 sn;		/* device serieal number, 0 if not support */
> 
> Typo: serieal


Thanks very much! Will update.


> 
>>  	struct pci_vpd *vpd;
>>  #ifdef CONFIG_PCI_ATS
>>  	union {
> 
> [...]
> 
> 
> Paul Bolle
> 
> 
> .
> 


-- 
Thanks!
Yijing

