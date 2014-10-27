Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaJ0LYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:24:20 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:8695 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaJ0LYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:24:19 -0400
Message-ID: <544E2B18.8010702@huawei.com>
Date: Mon, 27 Oct 2014 19:23:04 +0800
From: Li Liu <john.liuli@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Maydell <peter.maydell@linaro.org>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Schopp <joel.schopp@amd.com>,
        Yingshiuan Pan <yingshiuan.pan@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, <remy.gauguey@cea.fr>,
        Rusty Russell <rusty@rustcorp.com.au>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Nikolay Nikolaev" <n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        <peter.huangpeng@huawei.com>
Subject: Re: [Qemu-devel] [RFC PATCH 0/2] virtio-mmio: add irqfd support for
 vhost-net based on virtio-mmio
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com> <CAFEAcA9o8ZsbUvZb7Yp9JeO__bRLOrYcyfj4Ug4Se_rDF0y4TA@mail.gmail.com>
In-Reply-To: <CAFEAcA9o8ZsbUvZb7Yp9JeO__bRLOrYcyfj4Ug4Se_rDF0y4TA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.143.9]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/10/27 17:37, Peter Maydell wrote:
> On 25 October 2014 09:24, john.liuli <john.liuli@huawei.com> wrote:
>> To get the interrupt reason to support such VIRTIO_NET_F_STATUS
>> features I add a new register offset VIRTIO_MMIO_ISRMEM which
>> will help to establish a shared memory region between qemu and
>> virtio-mmio device. Then the interrupt reason can be accessed by
>> guest driver through this region. At the same time, the virtio-mmio
>> dirver check this region to see irqfd is supported or not during
>> the irq handler registration, and different handler will be assigned.
> 
> If you want to add a new register you should probably propose
> an update to the virtio spec. However, it seems to me it would
> be better to get generic PCI/PCIe working on the ARM virt
> board instead; then we can let virtio-mmio quietly fade away.
> This has been on the todo list for ages (and there have been
> RFC patches posted for plain PCI), it's just nobody's had time
> to work on it.
> 
> thanks
> -- PMM
> 

So you mean virtio-mmio will be replaced by PCI/PCIe on ARM at last?
If so, let this patch go with the wind:). Thx.

Li.
> .
> 

