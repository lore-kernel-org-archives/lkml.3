Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3C2BYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:24:52 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62102 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3C2BYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:24:51 -0400
Message-ID: <5154ED4D.9010509@huawei.com>
Date: Fri, 29 Mar 2013 09:24:29 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: Re: [PATCH] ia64: Fix example error_injection_tool
References: <5153B0ED.8020309@huawei.com> <3908561D78D1C84285E8C5FCA982C28F1E093C98@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1E093C98@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/29 0:47, Luck, Tony wrote:
> Nice catch.
> 
> -			mask[j]=1<<k;
> +			mask[j] = (unsigned long)1<<k;
> 
> Could use
> 			mask[j] = 1ul << k;
> to avoid the verbose cast.

Thank you for your suggestion, Tony.
I'll modify it in next version.

> 
> -Tony
> 
> 


