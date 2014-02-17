Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaBQG55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:57:57 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:3567 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaBQG54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:57:56 -0500
Message-ID: <5301B2DA.2030101@huawei.com>
Date: Mon, 17 Feb 2014 14:57:30 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IA64, sba_iommu: fix section mismatch
References: <1392616684-8410-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1392616684-8410-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static int __init
> +static int
>  acpi_sba_ioc_add(struct acpi_device *device,
>  		 const struct acpi_device_id *not_used)
>  {
> 

Hi Gerry,
   ioc_init() and sba_map_ioc_to_node() in this function seems also have the __init annotate.


-- 
Thanks!
Yijing

