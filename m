Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3F0GvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:51:00 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:16567 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3F0Gu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:50:58 -0400
Message-ID: <51CBE099.9040802@huawei.com>
Date: Thu, 27 Jun 2013 14:50:01 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 9/9] radeon: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
References: <1372209221-16492-1-git-send-email-wangyijing@huawei.com> <51CAE967.7080704@ti.com> <51CB9ABC.20704@huawei.com> <51CBDCE5.1020301@ti.com>
In-Reply-To: <51CBDCE5.1020301@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/27 14:34, Tomi Valkeinen wrote:
> On 27/06/13 04:51, Yijing Wang wrote:
>> On 2013/6/26 21:15, Tomi Valkeinen wrote:
> 
>>> I couldn't find the rest of this series, and I'm not familiar with PCI.
>>> So: is this patch and "aty128fb: use pdev->pm_cap instead of
>>> pci_find_capability(..,PCI_CAP_ID_PM)" safe to apply for fbdev-3.11
>>> without anything else? I.e. has the PCI core changes been merged in 3.10
>>> or ealier?
>>
>> Hi Tomi,
>>    Thanks for your reply. Yes, it's safe, because PCI core has been use pdev->pm_cap to save
>> the pm capability offset already. And PCI core changes related this pm init code has been merged
>> long long ago(since year 2008). This series changes just to simplifier driver code about pm code.
>> It's not necessary to access pci device register to get pm cap again, drivers can use pci device pm_cap
>> member. and this series had no changes in PCI core. The rest of this series like for bnx2, bnx2x etc has
>> been tested and accepted by other subsystems.
> 
> Ok, thanks. I'll apply the two patches to my fbdev-3.11 branch.
> 
>  Tomi
> 
> 

Thanks very much!

-- 
Thanks!
Yijing

