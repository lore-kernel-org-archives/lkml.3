Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaHAI5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:57:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58513 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAI5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:57:53 -0400
Message-ID: <53DB567F.2070400@huawei.com>
Date: Fri, 1 Aug 2014 16:57:35 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH] ARM: l2x0: fix build warning without CONFIG_OF
References: <1406860920-23520-1-git-send-email-wangkefeng.wang@huawei.com> <20140801075843.GO30282@n2100.arm.linux.org.uk>
In-Reply-To: <20140801075843.GO30282@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01 15:58, Russell King - ARM Linux wrote:
> On Fri, Aug 01, 2014 at 10:42:00AM +0800, Kefeng Wang wrote:
>> Commit cf9ea8f13(ARM: l2c: remove obsolete l2x0 ops for non-OF init)
>> remove some obsolete l2x0 ops, the rest of ops: l2x0_cache_sync,
>> l2x0_cache_sync, l2x0_disable only use under OF enable, so move them
>> into OF part, or "defined but not used" warning occurs.
> 
> I'm not interested; I've stated previously that I want these warnings
> to stay until such time that the code which uses them is fixed up to
> use the new methods.
> 
> The warnings act as an advertisment that it needs fixing properly.
> 

Ok, ignore pls.

