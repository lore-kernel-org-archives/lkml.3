Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbaBQHIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:08:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:18737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaBQHIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:08:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="482755528"
Message-ID: <5301B555.1030804@linux.intel.com>
Date: Mon, 17 Feb 2014 15:08:05 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IA64, sba_iommu: fix section mismatch
References: <1392616684-8410-1-git-send-email-jiang.liu@linux.intel.com> <5301B2DA.2030101@huawei.com>
In-Reply-To: <5301B2DA.2030101@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reminder, will send out v2.

On 2014/2/17 14:57, Yijing Wang wrote:
>> -static int __init
>> +static int
>>  acpi_sba_ioc_add(struct acpi_device *device,
>>  		 const struct acpi_device_id *not_used)
>>  {
>>
> 
> Hi Gerry,
>    ioc_init() and sba_map_ioc_to_node() in this function seems also have the __init annotate.
> 
> 
