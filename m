Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaJ0L6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:58:50 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:34955 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJ0L6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <544E2B18.8010702@huawei.com>
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
 <CAFEAcA9o8ZsbUvZb7Yp9JeO__bRLOrYcyfj4Ug4Se_rDF0y4TA@mail.gmail.com> <544E2B18.8010702@huawei.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 27 Oct 2014 11:58:26 +0000
Message-ID: <CAFEAcA8JgebH8B4i7aoSxdeon7B-eunXzZJhwOCXQr-ypSgfsQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC PATCH 0/2] virtio-mmio: add irqfd support for
 vhost-net based on virtio-mmio
To: Li Liu <john.liuli@huawei.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Schopp <joel.schopp@amd.com>,
        Yingshiuan Pan <yingshiuan.pan@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, remy.gauguey@cea.fr,
        Rusty Russell <rusty@rustcorp.com.au>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        peter.huangpeng@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2014 11:23, Li Liu <john.liuli@huawei.com> wrote:
> So you mean virtio-mmio will be replaced by PCI/PCIe on ARM at last?

That is the plan, yes. I can't make any promises on
timescales at the moment, though...

-- PMM
