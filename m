Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaKEJa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:30:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42436 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaKEJax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:30:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8JgebH8B4i7aoSxdeon7B-eunXzZJhwOCXQr-ypSgfsQ@mail.gmail.com>
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
	<CAFEAcA9o8ZsbUvZb7Yp9JeO__bRLOrYcyfj4Ug4Se_rDF0y4TA@mail.gmail.com>
	<544E2B18.8010702@huawei.com>
	<CAFEAcA8JgebH8B4i7aoSxdeon7B-eunXzZJhwOCXQr-ypSgfsQ@mail.gmail.com>
Date: Wed, 5 Nov 2014 10:30:53 +0100
Message-ID: <CAMJs5B-OXTCY=FWXK0ed3+VPk_9d3QUVBJ=ny3uq2z53cmv+KA@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC PATCH 0/2] virtio-mmio: add irqfd support for
 vhost-net based on virtio-mmio
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Li Liu <john.liuli@huawei.com>, Joel Schopp <joel.schopp@amd.com>,
        Yingshiuan Pan <yingshiuan.pan@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, remy.gauguey@cea.fr,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 12:58 PM, Peter Maydell
<peter.maydell@linaro.org> wrote:
> On 27 October 2014 11:23, Li Liu <john.liuli@huawei.com> wrote:
>> So you mean virtio-mmio will be replaced by PCI/PCIe on ARM at last?
>
> That is the plan, yes. I can't make any promises on
> timescales at the moment, though...
>
Linaro has scheduled resources to work on this (Ard, cc'ed) and we
expect to be able to deliver this within a reasonable time frame.

-Christoffer
