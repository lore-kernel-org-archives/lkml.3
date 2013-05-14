Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3ENGDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:03:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30044 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3ENGDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:03:36 -0400
Message-ID: <5191D378.8060600@huawei.com>
Date: Tue, 14 May 2013 14:02:32 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] PCI: move resources and bus_list releasing to pci_release_dev
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org> <1368498506-25857-3-git-send-email-yinghai@kernel.org> <5191AD65.7090105@huawei.com> <CAE9FiQWty+iSv3RdfesoyDZ3q15QeX4fJGFcXS8PxTCese-XzQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWty+iSv3RdfesoyDZ3q15QeX4fJGFcXS8PxTCese-XzQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/14 11:56, Yinghai Lu wrote:
> On Mon, May 13, 2013 at 8:20 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> On 2013/5/14 10:28, Yinghai Lu wrote:
>>> We should not release resource in pci_destroy that is too early
>>
>> Hi Yinghai,
>>    "too early" means that after pci_stop_dev(), if someone else
>> hold the device reference, it still care the device resource ? e.g.?
> 
> I don't mean that.
> 
>>
>>> as there could be still other use hold reference.
> 
> purpose is:
> move res releasing as late as possible. so pci_stop_and_remove_bus_device
> could be called several times for nested removing via sys.

OK, thanks for explanation.

Thanks!
Yijing.

> 
> Yinghai
> 
> 


-- 
Thanks!
Yijing

