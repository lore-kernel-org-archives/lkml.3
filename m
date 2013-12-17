Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3LQBNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:13:25 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:53855 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3LQBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:13:24 -0500
Message-ID: <52AFA3BB.5070901@huawei.com>
Date: Tue, 17 Dec 2013 09:07:07 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, qiuxishi <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] mm/hugetlb: check for pte NULL pointer in __page_check_address()
References: <52AEC8FD.6050200@huawei.com> <20131216142513.784A8E0090@blue.fi.intel.com>
In-Reply-To: <20131216142513.784A8E0090@blue.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 2013/12/16 22:25, Kirill A. Shutemov wrote:

> Jianguo Wu wrote:
>> In __page_check_address(), if address's pud is not present,
>> huge_pte_offset() will return NULL, we should check the return value.
>>
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> 
> Looks okay to me.
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> 
> Have you triggered a crash there? Or just spotted by reading the code?
> 


By reading the code.

Thanks,
Jianguo Wu

