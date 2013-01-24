Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3AXCVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:21:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16813 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3AXCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:21:07 -0500
Message-ID: <51009A7F.6050104@huawei.com>
Date: Thu, 24 Jan 2013 10:20:47 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Rob Landley <rob@landley.net>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jon Mason <jdmason@kudzu.us>, <linux-pci@vger.kernel.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [Update][PATCH] PCI: Document PCIE BUS MPS parameters
References: <1358944092-28884-1-git-send-email-wangyijing@huawei.com> <510074C7.6090203@infradead.org> <510094A4.3040806@huawei.com> <51009645.5040406@infradead.org>
In-Reply-To: <51009645.5040406@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/24 10:02, Randy Dunlap wrote:
> On 01/23/13 17:55, Yijing Wang wrote:
>> Hi Randy,
>>    Thanks for your review and comments! please refer to inlined comments below.
>>
>> On 2013/1/24 7:39, Randy Dunlap wrote:
>>> On 01/23/13 04:28, Yijing Wang wrote:
> 
>>>
>>> What is (are) MRRS?
>>
>> MRRS is "Max Read Request Size" and MPS is "Max Payload Size".
>> Need use "Max Read Request Size" instead of MRRS ?
> 
> Where is MRRS documented?

The description of MRRS can be found at PCIe Spec 2.0/3.0 7.8.4 Device Control Register.

> 
> I would probably do it like so:
> 
> Also set MRRS (Max Read Request Size) to the ....

Hmm, I will explain MPS and MRRS when they appear first time like,

pcie_bus_tune_off   Disable PCIe MPS (Max Payload Size) turning and using
		the BIOS-configured MPS defaults.

pcie_bus_perf	......Also set MRRS (Max Read Request Size) to the......

Thanks!
Yijing

> 


-- 
Thanks!
Yijing

