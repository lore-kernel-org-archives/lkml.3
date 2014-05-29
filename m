Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbaE2I6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:58:24 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:17657 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbaE2I6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:58:22 -0400
Message-ID: <5386F663.4010401@huawei.com>
Date: Thu, 29 May 2014 16:57:07 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Yong Zhang <yong.zhang@windriver.com>, <ralf@linux-mips.org>,
        <huawei.libin@huawei.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com> <5384119E.7010606@huawei.com> <20140528200929.GA30528@drone.musicnaut.iki.fi>
In-Reply-To: <20140528200929.GA30528@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/29 4:09, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, May 27, 2014 at 12:16:30PM +0800, Li Zefan wrote:
>> On 2014/5/21 13:36, Yong Zhang wrote:
>>> asid_cache must be unsigned long otherwise on 64bit system
>>> it will become 0 if the value in get_new_mmu_context()
>>> reaches 0xffffffff and in the end the assumption of
>>> ASID_FIRST_VERSION is not true anymore thus leads to
>>> more dangerous things.
>>
>> We should describe what problem this bug can lead to, which
>> will help people who encounter the same problem and google it.
> 
> Please describe it, then. Even if the patch is already committed,
> googling would probably still find this e-mail thread.
> 

I don't think Ralf has committed it, so we'll send out a fix
with detailed changelog.

